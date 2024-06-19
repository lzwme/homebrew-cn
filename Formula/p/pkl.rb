class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https:pkl-lang.org"
  url "https:github.comapplepklarchiverefstags0.26.0.tar.gz"
  sha256 "2c01c67ad05ad0dad800395781d380fa1ce7f837af23bcff016e9e80b8b930e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "248a5e6c8f668f21416a8b1ba4ac6b7b2d2b9f46221bd4d705610c625050901b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76acd8bc30560d79a7917ad04eb9e2a2156e57387963b030404568bfc849515f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d50a6e5b1f16b8a4d1117e3582c6a20bd2a9798e1e4fdeea08bdc3d183b1d27"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3dd4e30884a99a512dd6a396c8edfc31f7103f215cfa543e17a7ac4d7ade616"
    sha256 cellar: :any_skip_relocation, ventura:        "4e2c1a6ccb588311663b725cc0d1b3fbf801420b57c5bf03d699aaebf972a4c5"
    sha256 cellar: :any_skip_relocation, monterey:       "6742090a59116698879e6e9bba3128b46a7355dd3d413da529351b60fcdb4145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d902768b87e60643ebdbc9f5081c9cc39b3b5e869cb1cd66a98354cf733daa8"
  end

  # Can change this to 21 in later releases.
  depends_on "openjdk@17" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    # Need to set this so that native-image passes through env vars when calling out to the C toolchain.
    ENV["NATIVE_IMAGE_DEPRECATED_BUILDER_SANITATION"] = "true"

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    system ".gradlew", "-DreleaseBuild=true", job_name
    bin.install "pkl-clibuildexecutablepkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}pkl --version")
  end
end