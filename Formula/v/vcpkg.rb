class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https:github.commicrosoftvcpkg"
  # Newer than what livecheck picks up, but we need it for fmt 11.
  url "https:github.commicrosoftvcpkg-toolarchiverefstags2024-08-01.tar.gz"
  version "2024.08.01"
  sha256 "cb94fa640676e4577ed39fc763178f4661848b5321207c74b3ea411e45f1a95c"
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
    sha256 cellar: :any,                 arm64_sonoma:   "05d39f76c60b855c77c248264968aed2dd94ebfcd554ef3302c983da45dfa484"
    sha256 cellar: :any,                 arm64_ventura:  "17e02b956aafdf843425b42c044ebf80f337b35370c4f7491ea3726aecb2c459"
    sha256 cellar: :any,                 arm64_monterey: "c18d4e9e5382bbbacdb6d7545a020681f6bf754f5b17eed0c3e166b0350a7578"
    sha256 cellar: :any,                 sonoma:         "4b5aa04f210c602ad8115d43040a7cd0ee1999c24193ed415b75b9a485885def"
    sha256 cellar: :any,                 ventura:        "6e2c26518b8a265edf71b156a779e7212f8fbbc7947fd772452e5f87fd89b181"
    sha256 cellar: :any,                 monterey:       "e6d9148c1eb7958217105e70ec1136c7e11e788b33ec871ef085413b38332879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00f3192624d9f4fb500715b6c241ae8be79d793f96adbe2c30da9e3937ebfe5"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "localesmessages.json" do |s|
      s.gsub! "If you are trying to use a copy of vcpkg that you've built, y", "Y"
      s.gsub! " to point to a cloned copy of https:github.comMicrosoftvcpkg", ""
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    "-DHOMEBREW_ALLOW_FETCHCONTENT=ON", # FIXME: Remove this
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
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root."
    assert_match message, shell_output("#{bin}vcpkg search sqlite 2>&1", 1)
  end
end