class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.8.3.tar.gz"
  sha256 "41a21a5d28af450b20dc416bba1259dba2b9ecbde0b63f1f997b708f9ebe60de"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e493c1be2ca3699f33451d9498052f07c9402fafb9033c634d32612cae8745c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f0e74daa41a00fc82c021369c6182eed6a795379219c4a3c13f121096edc83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed4fd33e59e46ea60f6c5040e7aab1df0dc4d35a24aaafa593874102d6c017e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "90a0beb65aa58651b7d60126c978131ac3905c8704d830d922c4018b5cf8d2f3"
    sha256 cellar: :any_skip_relocation, ventura:       "b4befd056a78b99a51c73b40c2a1a20e92313de5c651c42acecca84b03c9009b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef483ff3e0404892e609b1db1dbd165be8927468eb433be97f12c3b7e62edff5"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensionsscarb-cairo-language-server
      extensionsscarb-cairo-run
      extensionsscarb-cairo-test
      extensionsscarb-snforge-test-collector
      extensionsscarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}Scarb.toml", shell_output("#{bin}scarb manifest-path")

    system bin"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath"srclib.cairo", :exist?
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}scarb snforge-test-collector --version")
    assert_match version.to_s, shell_output("#{bin}scarb doc --version")
  end
end