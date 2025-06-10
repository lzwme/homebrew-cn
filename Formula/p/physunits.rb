class Physunits < Formula
  desc "C++ header-only for Physics unitquantity manipulation and conversion"
  homepage "https:github.commartinmoenePhysUnits-CT-Cpp11"
  url "https:github.commartinmoenePhysUnits-CT-Cpp11archiverefstagsv1.2.0.tar.gz"
  sha256 "e9bcce99d9c90ac8ce96746eff49c20b7c9717aee08b3cd6e58127c7ad9fa7c6"
  license "BSL-1.0"
  head "https:github.commartinmoenePhysUnits-CT-Cpp11.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d1aab63a49f0f5ca8b530354e7efe1b884c7d57e69509aca43bc4416191e3079"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "builddir", *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <physunitsquantity.hpp>
      #include <iostream>
      using namespace std;
      using namespace phys::units;
      using namespace phys::units::literals;

      int main()
      {
        quantity<speed_d> speed = 45_km  hour;
        cout<<speed.magnitude()<<endl;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_match(12.5, shell_output(".test"))
  end
end