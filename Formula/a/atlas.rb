class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.31.0.tar.gz"
  sha256 "f4464ead567f8183ea0f42808f2cd84f32b1a177852ff20ee18b0df49daf5976"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06ee68948a297d4baee122be601981fc3b6d2f64c9da75ea7a54ce817627e615"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f6b09a76bfe3fe030247bd180632587d88d57add9a725009d7cb62211ed127"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8d80b29311771db36786d37b9434add3fd1acd74b479434b0012c171f463434"
    sha256 cellar: :any_skip_relocation, sonoma:        "705633629f3d8355ba7e5ce6b17999fa84217cf49e23304505757f6b20815b02"
    sha256 cellar: :any_skip_relocation, ventura:       "b9cb5ee72f21ed8b04fa6ec0dba25e47567a6e43227440e711caf388d74ad696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "575e80177a3a1396be2e22fe9691232e116773ce9d2ffa81ab16014cae72054a"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end