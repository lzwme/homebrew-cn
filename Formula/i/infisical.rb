class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.83.tar.gz"
  sha256 "e5ee936ec12965c969af18ac3ac461def72e3395cf27882a4b0cc4501da13910"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "552ebd71017a5b34ffb1ef00be80a5f9b9793d05c687855c10b307651afccf70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "552ebd71017a5b34ffb1ef00be80a5f9b9793d05c687855c10b307651afccf70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "552ebd71017a5b34ffb1ef00be80a5f9b9793d05c687855c10b307651afccf70"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0aaecd7b58f45f41f3c3b1c2abe9ffc7c7e6ff9852e3e973006b15f4d91f41c"
    sha256 cellar: :any_skip_relocation, ventura:       "e0aaecd7b58f45f41f3c3b1c2abe9ffc7c7e6ff9852e3e973006b15f4d91f41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1505a2bb0e184f71afbc833724b7da281a00a4579fc5c52cd054482f637a3cec"
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