"""
POS Calculator - Main Runner
Run this file to start everything
"""
import sys
import os

def main():
    print("🎯 POS Calculator System")
    print("=" * 40)
    
    # Add src to path
    sys.path.append('src')
    
    try:
        # Test the calculator
        from pos_calculator import POSCalculator
        
        print("✓ Calculator module loaded successfully!")
        print("\n🧪 Running quick test...")
        
        calculator = POSCalculator()
        result = calculator.calculate_order_total([
            {"id": "T1", "type": "ticket", "quantity": 2}
        ])
        
        print(f"✓ Quick test passed! 2 Basic Tickets = ${result}")
        print("\n🚀 Starting web server...")
        print("   The server will start on http://localhost:12500")
        print("   Press Ctrl+C to stop the server")
        print("=" * 40)
        
        # Start the web server
        from src.app import app
        app.run(host='0.0.0.0', port=12500, debug=True)
        
    except ImportError as e:
        print(f"❌ Error: {e}")
        print("Make sure all files are in the correct locations:")
        print("  - src/pos_calculator.py")
        print("  - src/app.py") 
        print("  - data/Pos_backup.json")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    main()