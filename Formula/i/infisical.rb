class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.85.tar.gz"
  sha256 "f530480aaa6961617ac17877615df50fdcacc413fbe0adad53795e58e166d2ac"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857158ede07931a0ed126717c6908dadcd305845a656f95101db5eb1e5c0a078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857158ede07931a0ed126717c6908dadcd305845a656f95101db5eb1e5c0a078"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "857158ede07931a0ed126717c6908dadcd305845a656f95101db5eb1e5c0a078"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e57cd6653311bd60cffcf0853111b6661f690659bf1edc1dfe8dcc3380d1b6"
    sha256 cellar: :any_skip_relocation, ventura:       "53e57cd6653311bd60cffcf0853111b6661f690659bf1edc1dfe8dcc3380d1b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef67ae02d8ea100c7b7dbdaa24948ecb37b49ff72650069ed3d4b0060be7f7c7"
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