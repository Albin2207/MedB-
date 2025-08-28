import 'package:flutter/material.dart';
import 'package:medb_app/data/models/user_model/user_model.dart';
import 'package:medb_app/data/services/storage_service.dart';
import 'package:medb_app/core/theme.dart';

class ProfilePanel extends StatefulWidget {
  final UserDetails user;
  const ProfilePanel({super.key, required this.user});

  @override
  State<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<ProfilePanel> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameCtrl;
  late TextEditingController middleNameCtrl;
  late TextEditingController lastNameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController genderCtrl;
  late TextEditingController designationCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController contactCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController districtCtrl;
  late TextEditingController stateCtrl;
  late TextEditingController countryCtrl;
  late TextEditingController postalCodeCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    firstNameCtrl = TextEditingController(text: u.firstName);
    middleNameCtrl = TextEditingController(text: u.middleName);
    lastNameCtrl = TextEditingController(text: u.lastName);
    ageCtrl = TextEditingController(text: u.age ?? '');
    genderCtrl = TextEditingController(text: u.gender ?? '');
    designationCtrl = TextEditingController(text: u.designation ?? '');
    emailCtrl = TextEditingController(text: u.email);
    contactCtrl = TextEditingController(text: u.contactNo);
    addressCtrl = TextEditingController(text: u.address ?? '');
    cityCtrl = TextEditingController(text: u.city ?? '');
    districtCtrl = TextEditingController(text: u.district ?? '');
    stateCtrl = TextEditingController(text: u.state ?? '');
    countryCtrl = TextEditingController(text: u.country ?? '');
    postalCodeCtrl = TextEditingController(text: u.postalCode ?? '');
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    middleNameCtrl.dispose();
    lastNameCtrl.dispose();
    ageCtrl.dispose();
    genderCtrl.dispose();
    designationCtrl.dispose();
    emailCtrl.dispose();
    contactCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    districtCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    postalCodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    // Build updated UserDetails (keep unchanged IDs/clinic info)
    final updated = UserDetails(
      id: widget.user.id,
      userId: widget.user.userId,
      clinicId: widget.user.clinicId,
      doctorId: widget.user.doctorId,
      doctorClinics: widget.user.doctorClinics,
      firstName: firstNameCtrl.text.trim(),
      middleName: middleNameCtrl.text.trim(),
      lastName: lastNameCtrl.text.trim(),
      age: ageCtrl.text.trim().isEmpty ? null : ageCtrl.text.trim(),
      gender: genderCtrl.text.trim().isEmpty ? null : genderCtrl.text.trim(),
      designation:
          designationCtrl.text.trim().isEmpty
              ? null
              : designationCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      contactNo: contactCtrl.text.trim(),
      address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
      city: cityCtrl.text.trim().isEmpty ? null : cityCtrl.text.trim(),
      district:
          districtCtrl.text.trim().isEmpty ? null : districtCtrl.text.trim(),
      state: stateCtrl.text.trim().isEmpty ? null : stateCtrl.text.trim(),
      country: countryCtrl.text.trim().isEmpty ? null : countryCtrl.text.trim(),
      postalCode:
          postalCodeCtrl.text.trim().isEmpty
              ? null
              : postalCodeCtrl.text.trim(),
      profilePicture: widget.user.profilePicture,
    );

    try {
      await StorageService().saveUserDetails(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated.'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.of(context).pop(); // close panel after save
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save profile: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _buildField(
    TextEditingController ctrl,
    String hint, {
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: (val) {
          // minimal validation for required fields
          if ((hint == 'First Name*' ||
                  hint == 'Last Name*' ||
                  hint == 'Email*' ||
                  hint == 'Contact No*') &&
              (val == null || val.trim().isEmpty)) {
            return 'Required';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint.replaceAll('*', ''),
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color(0xFFEDEDED)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    final width = MediaQuery.of(context).size.width;
    final panelHeight = MediaQuery.of(context).size.height * 0.92;

    return SafeArea(
      child: Container(
        height: panelHeight,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Material(
            color: const Color(0xFFF6F6FB), // pale background like screenshot
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: width > 600 ? 600 : width,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 22,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.primaryColor, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          "${u.firstName} ${u.lastName}'s Profile",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),

                        // Avatar
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(
                            (u.firstName.isNotEmpty
                                ? u.firstName[0].toUpperCase()
                                : 'A'),
                            style: const TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // placeholder: implement image picker if needed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Profile picture update not implemented.',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Update Profile Picture',
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Fields (first row maybe)
                        _buildField(firstNameCtrl, 'First Name*'),
                        _buildField(middleNameCtrl, 'Middle Name'),
                        _buildField(lastNameCtrl, 'Last Name*'),

                        _buildField(
                          ageCtrl,
                          'Age',
                          keyboardType: TextInputType.number,
                        ),
                        _buildField(genderCtrl, 'Gender'),
                        _buildField(designationCtrl, 'Designation'),

                        _buildField(
                          emailCtrl,
                          'Email*',
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildField(
                          contactCtrl,
                          'Contact No*',
                          keyboardType: TextInputType.phone,
                        ),

                        _buildField(addressCtrl, 'Address'),
                        _buildField(cityCtrl, 'City'),
                        _buildField(districtCtrl, 'District'),
                        _buildField(stateCtrl, 'State'),
                        _buildField(countryCtrl, 'Country'),
                        _buildField(postalCodeCtrl, 'Postal Code'),

                        const SizedBox(height: 14),

                        // Update Profile Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _saving ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child:
                                _saving
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'Update Profile',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Secondary outlined button (Update Contact No.)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              // optionally open contact update flow
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Contact update flow not implemented.',
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppTheme.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: Text(
                              'Update Contact No.',
                              style: TextStyle(color: AppTheme.primaryColor),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
