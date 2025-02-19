class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.10.0.tar.gz"
  sha256 "ddea066873fc3069d7a8b947f280cbd47d04906eddb352a23eaf742bc2c3b857"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b754edca0cdb559c2de4fd7aebc9cb9991db7233b313bb9e31c557e7d3683baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "021cf5e2adefc1685c6a238df54574190e9fe6268c09d92673dc708afe63de06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53e52357634fe8fde8521cdf866f0332eeffa8b69b2e819f793749bdf4e61e2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9311c9d995bee3ffde03f5426bf66e59d5126c919ec5fef96b440aa49c036044"
    sha256 cellar: :any_skip_relocation, ventura:       "18508a6ddd5f54e19ad284c305e43b4350a374866e42d080fcba47c122da0c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3debed957015dce5115a798ff6f9c2ea207662d82e6c476b04af37abd7d293"
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
    assert_path_exists testpath"srclib.cairo"
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}scarb doc --version")
  end
end