class FortranIos < Formula
  desc "Fortran compiler for iOS ARM64"
  homepage "https://github.com/ColdGrub1384/fortran-ios"
  version "2.3"
  on_intel do
    url "https://ghproxy.com/https://github.com/ColdGrub1384/fortran-ios/releases/download/v#{version}/fortran-ios-macos-86_64.zip"
    sha256 "a311dd2f91859384a8a4d38ed2a204219c9122db9d76f06500316292c751afc3"
  end
  on_arm do
    url "https://ghproxy.com/https://github.com/ColdGrub1384/fortran-ios/releases/download/v#{version}/fortran-ios-macos-arm64.zip"
    sha256 "d9912e2d4361ca0045b1aea39c8217c3551ff7565fa7e720400381dacf5c3295"
  end

  depends_on "docker"

  def install
    inreplace "bin/gfortran", '"flang.sh"', '"fortran-ios-flang.sh"'
    inreplace "bin/gfortran", '"llc"', '"fortran-ios-llc"'
    bin.install "bin/gfortran" => "fortran-ios-gfortran"
    bin.install "bin/flang.sh" => "fortran-ios-flang.sh"
    bin.install "bin/llc" => "fortran-ios-llc"
    share.install Dir["share/*"]
  end
end