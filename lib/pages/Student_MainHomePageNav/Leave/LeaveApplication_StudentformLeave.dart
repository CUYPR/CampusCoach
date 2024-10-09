import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:flutter/services.dart'; 

class LeaveApplication_StudentformLeave extends StatefulWidget {
  @override
  _LeaveApplicationStudentFormLeaveState createState() =>
      _LeaveApplicationStudentFormLeaveState();
}

class _LeaveApplicationStudentFormLeaveState
    extends State<LeaveApplication_StudentformLeave> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  String _selectedLeaveType = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Application Form'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double largeTextSize = screenWidth * 0.08;
          double smallTextSize = screenWidth * 0.04;

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), 
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildSectionTitle('Title', smallTextSize),
                  _buildTextField('Enter title', screenWidth, 60),

                  SizedBox(height: screenHeight * 0.02),

                  
                  _buildSectionTitle('Leave Type', smallTextSize),
                  _buildDropdown(screenWidth),

                  SizedBox(height: screenHeight * 0.04),

                  
                  _buildSectionTitle('Contact Number', smallTextSize),
                  _buildTextField('Enter contact number', screenWidth, 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly]),

                  SizedBox(height: screenHeight * 0.03),

                  
                  _buildSectionTitle('Dates', smallTextSize),
                  _buildDateRow(screenWidth, context),

                  SizedBox(height: screenHeight * 0.048),

                  
                  _buildSectionTitle('Proof File Attachment', smallTextSize),
                  _buildFileAttachmentBox(screenWidth, screenHeight),

                  SizedBox(height: screenHeight * 0.03),

                  
                  _buildSubmitButton(context, screenWidth, screenHeight),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String text, double textSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(String hintText, double screenWidth, int maxLength,
      {TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          borderSide: BorderSide(color: const Color(0xC7C0CFFA)), 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          borderSide: BorderSide(color: const Color(0xFF566DA1)), 
        ),
      ),
    );
  }

  Widget _buildDropdown(double screenWidth) {
    return DropdownButtonFormField<String>(
      value: _selectedLeaveType.isNotEmpty ? _selectedLeaveType : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          borderSide: BorderSide(color: const Color(0xC7C0CFFA)), 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          borderSide: BorderSide(color: const Color(0xFF566DA1)), 
        ),
      ),
      items: ['Sick Leave', 'Casual Leave', 'Emergency Leave']
          .map((type) => DropdownMenuItem(
        child: Text(type),
        value: type,
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedLeaveType = value!;
        });
      },
      hint: Text('Select leave type'),
      isExpanded: true, 
    );
  }

  Widget _buildDateRow(double screenWidth, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, 'start'),
            child: AbsorbPointer(
              child: TextField(
                controller: _startDateController,
                decoration: InputDecoration(
                  hintText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide(color: const Color(0xC7C0CFFA)), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide(color: const Color(0xFF566DA1)), 
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.06), 
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, 'end'),
            child: AbsorbPointer(
              child: TextField(
                controller: _endDateController,
                decoration: InputDecoration(
                  hintText: 'End Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide(color: const Color(0xC7C0CFFA)), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    borderSide: BorderSide(color: const Color(0xFF566DA1)), 
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileAttachmentBox(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.15,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF94A4C9), width: 2),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Center(
        child: Text(
          'Attach File',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, double screenWidth, double screenHeight) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          
          
          
          
        },
        child: Text(
          'Apply',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, 
          backgroundColor: const Color(0xFF566DA1), 
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      if (type == 'start') {
        setState(() {
          _startDateController.text = formattedDate;
        });
      } else if (type == 'end') {
        setState(() {
          _endDateController.text = formattedDate;
        });
      }
    }
  }
}
