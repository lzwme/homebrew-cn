class Dra < Formula
  desc "Command-line tool to download release assets from GitHub"
  homepage "https:github.comdevmatteinidra"
  url "https:github.comdevmatteinidraarchiverefstags0.6.3.tar.gz"
  sha256 "86297c42c6bc751a8ce04e380757b0e22ed50305b2758f8cdefacd4b64cf0ad0"
  license "MIT"
  head "https:github.comdevmatteinidra.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0773f8510791e01e05dd822a1a8c6edb2928992662854ddae145b89008f62b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db2c7320373c63aadbbecf68dcfd524e1ab5369b01ea487d00d9faad1fac23f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "511c7b382d671033f54a090c2ab0c10ab64751488ce8993530efba2265851415"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3053d112229db31194f13ffc0d1b4a24e8f9f4cc69cdeacbf45b37ca00be0e3"
    sha256 cellar: :any_skip_relocation, ventura:       "d0ec6433c0b674e935c6b989e0c88afcff94d8a418791b29097ae41e7a0a8157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a5c547ada3eefaccc276b8add97a358617fa9aad2a4df00a58b7bebe7dd4a2a"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"dra --version")

    system bin"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteinidra-tests"

    assert_predicate testpath"helloworld.tar.gz", :exist?
  end
end