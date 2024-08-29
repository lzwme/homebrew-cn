class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.8.0.tar.gz"
  sha256 "e2cc4dbc4f72efb60f983b3c62eaefc0b040bf3930e753c45cc92a185c3cde9d"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80613bace925d3a3082b74526948e30885087d4dbed81aa3ff2bd33272374112"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b59a1cd38d333083797728176d907c7232329d1c49aa9b474c77825d0c58c03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8123fc3b812a0a64f58643ad0bf1051e7a6e9a7fe68bb99001c00925e6fbf4d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6adf8c81ddd8f8753fb3190f177774a0bccffd62e178e45577ddb753ff0fbe29"
    sha256 cellar: :any_skip_relocation, ventura:        "5d2a1d57c79b388509ecae04ea7257e35059cc955666cf2b889014568da563a7"
    sha256 cellar: :any_skip_relocation, monterey:       "b16a720b0685d56c2a6e5ef27719c9e94b8310157a340d0a3d235e9aa24dbf5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7829cf5a557745848808c7da0366e73ccfd9ad38f2618b50f52c5c2179391ee2"
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