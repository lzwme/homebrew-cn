class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.10.1.tar.gz"
  sha256 "197eeb4507fff9cf0190721d24ccf2d537b6880246527d8b70c7646109a414ed"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47218df021b5953921c960b070c0ef110f0ebda05fa3a4d30fb8ff7100e7ea8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dacf68e226bc45ce6354ba44c97438086956f7466086468aed9a959ffcfdc49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e638fdfc53f4b0d8ea4cfc612a9cefe8ca7fbe66cd244d9da8567b5f42e690f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "22b8fca100bcaa68fd0d66095fc9d847a561d74137b4515794cbece9714fc035"
    sha256 cellar: :any_skip_relocation, ventura:       "b9d998fb39b6119c1e02624471e8136458f8ca8e83c07ce33abdb3d8337d2818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4c27fc5c10182b91b37626a7f36ff39d4ba9b1328be2f44209ae64f5c36931"
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