class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.9.1.tar.gz"
  sha256 "4288122fbd818173dc83e71482678569927c886886eb85cd46b0f49233476016"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb3fc15b838edc1d7a324a677870ed1f11342a0b83df589ac818d98ecdabebd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c726f44c0a01ddd2cdfbe03ea7e2c44a1fb0991366fa933999f82cfefc3921d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94a49e076b71e94f7733bfbdb442aa529ca8146d3a5d0f84a7906ecbd32b4f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "88446e07fdeaad99aeeca36ee373c95f7049535979d513d25a610e7682b5b8ab"
    sha256 cellar: :any_skip_relocation, ventura:       "017ff68a653fb13b1b9353a3ca4426fb8d31eccd134fe0598ad3e539da155ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "769d729a5ce758a654bc429d4a19b338ce573cf7ca8ec8396a25d5a85911882b"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  # bump bytes to 1.9.0, upstream pr ref, https:github.comsoftware-mansionscarbpull1792
  patch do
    url "https:github.comsoftware-mansionscarbcommitdb39977319ac434a1ea34d8185a064dfe0bbaee3.patch?full_index=1"
    sha256 "2af4dbf24584cea578cc0127a4b9d142c81914b90fe0372627351a47fde9fa0a"
  end

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