class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2025-02-11.tar.gz"
  version "2025.02.11"
  sha256 "19003c7958ea5cfc8583c6a90f9abd57bf1fe48d8bc5e8a757697edd0050b0c6"
  license "MIT"
  head "https:github.commicrosoftvcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(v?(\d{4}(?:[._-]\d{2}){2})i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a47eb26c863a212c65cdb57652d68ddc01f74ac8ecfd67944fd857ff9b1765b8"
    sha256 cellar: :any,                 arm64_sonoma:  "e4610572138fdb6f67208d9eb772827fd5b8895f27138a5b620e8be2d0e6e407"
    sha256 cellar: :any,                 arm64_ventura: "d503b7872a0cfb3508e5cad284796a268cf876b12fafd324789819e1b2199e02"
    sha256 cellar: :any,                 sonoma:        "9bc9447c59b7d55ea1d483c7263be3ea0ef6ee639d6a288c8caf0f7434f2f9e2"
    sha256 cellar: :any,                 ventura:       "826ab7c281d97569a18bf93585804d28968140cf7e69eb0dc1b257968cf14475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7093b31be7244b6a3be6da679023a040954ae2696608514a6c31f0b81c899b3b"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "includevcpkgbasemessage-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    "-DVCPKG_DEPENDENCY_CMAKERC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https:github.commicrosoftvcpkg "$HOMEvcpkg"
        export VCPKG_ROOT="$HOMEvcpkg"
    EOS
  end

  test do
    output = shell_output("#{bin}vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end