class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.9.3.tar.gz"
  sha256 "43ead01c43b0cd7abc4bae1b866991c743fefce24a2b41221a1b7986bf86a04e"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b490331dd1c01fc323dc8f259a3ae8ce013c6f4b74ce6f3557d9ea67ab9e2863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ed5cbe966f5dc9479876512f0c6f95d181d62b54afc45e8e62b03a7f45ddf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68d453d4fc8a6af5dade1d78a4f5667cc8dace53a6123dadb3eb2942808a84de"
    sha256 cellar: :any_skip_relocation, sonoma:        "70a0ff0fa59a86959a5e504d5e5e96130d0e354e3f5ca1644c124149937cb27f"
    sha256 cellar: :any_skip_relocation, ventura:       "4be13b97fcc97dfa6b6077ddfd3f70833daa3db5cfa9ccc64d6cafe9ce985818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82bfaa6332428e6dd181fe223733d8ed98eb35712782c541adf3362861a4da99"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensionsscarb-cairo-language-server
      extensionsscarb-cairo-run
      extensionsscarb-cairo-test
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
    assert_match version.to_s, shell_output("#{bin}scarb doc --version")
  end
end