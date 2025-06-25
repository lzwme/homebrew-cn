class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.86.tar.gz"
  sha256 "12d756a656352112baa8ce047abc4bb3eeddf4fb1bf11e05faeedb514553052e"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e47c53023c782eb86bce8cd9fa88f8daafee6a783800f607db0e9cfed757e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e47c53023c782eb86bce8cd9fa88f8daafee6a783800f607db0e9cfed757e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e47c53023c782eb86bce8cd9fa88f8daafee6a783800f607db0e9cfed757e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f7c39532c50a12718a7563862bd64cd61065509eebde2208719ac9164cee5ec"
    sha256 cellar: :any_skip_relocation, ventura:       "5f7c39532c50a12718a7563862bd64cd61065509eebde2208719ac9164cee5ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d14ac04f0b78a830fff75b6060473cbf72c566cb11ba76afbd5b7d752190aa7"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end