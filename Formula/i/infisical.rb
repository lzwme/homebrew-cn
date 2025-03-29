class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.22.tar.gz"
  sha256 "1c9fa5162bbce661979740831d23a3cd08a25edfb85134c751e1946c448d5582"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f22d57345297022360aa151245a90c3cfa684e4e9d666228a3d7cf01bcf3de5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f22d57345297022360aa151245a90c3cfa684e4e9d666228a3d7cf01bcf3de5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f22d57345297022360aa151245a90c3cfa684e4e9d666228a3d7cf01bcf3de5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a70ab462c842c4a5f8d8f7cce72a0794894acb573c1cb0e323f1ba29a57ccbe"
    sha256 cellar: :any_skip_relocation, ventura:       "2a70ab462c842c4a5f8d8f7cce72a0794894acb573c1cb0e323f1ba29a57ccbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15604b191d4375225d36f66ae3358f492424e689c89a07ddbe9b378281319ccd"
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

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end