class Chainsaw < Formula
  desc "Rapidly Search and Hunt through Windows Forensic Artefacts"
  homepage "https:github.comWithSecureLabschainsaw"
  url "https:github.comWithSecureLabschainsawarchiverefstagsv2.10.1.tar.gz"
  sha256 "f2130aa7c4d918dd4c96461ab9860348e742e3b50ccc8d02aea92878156eaf8f"
  license "GPL-3.0-only"
  head "https:github.comWithSecureLabschainsaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9d09b4fe258c7427adf1e267a2fbd359700f00c8247d67195c6981cc90f924d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4058b9b72d3c0dbb3511ffcf762294a5cf5219a0022023696e0d9d618ce00ff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31ac4b0413f89ab2e4cef5304c752dac9e277200e4ffe7785f0870f989293401"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d252638d0b2f79103da90ad6feb0228eecf6a1ab01e89c6a55bb7d19feee78c"
    sha256 cellar: :any_skip_relocation, ventura:       "6e1bb72904c449a3fc87e5a18943e157db78cb66de60edea563b84a82a54737e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dec235ca858f7e13e258c244f2b847b23f5b5de4ba7521305d1c363a174bc10"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "chainsaw" do
      output = shell_output("#{bin}chainsaw lint --kind chainsaw . 2>&1")
      assert_match "Validated 0 detection rules out of 0", output

      output = shell_output("#{bin}chainsaw dump --json . 2>&1", 1)
      assert_match "Dumping the contents of forensic artefact", output
    end

    assert_match version.to_s, shell_output("#{bin}chainsaw --version")
  end
end