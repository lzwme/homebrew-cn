class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https:getsops.io"
  url "https:github.comgetsopssopsarchiverefstagsv3.10.0.tar.gz"
  sha256 "a749e633ed68a0f357c7dfc3b005395c8697c18c1c88547f6b599a7169e20b37"
  license "MPL-2.0"
  head "https:github.comgetsopssops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a67accb3fd57d144000c28dd0d6c176387cd832b365de43f4e70d1d72632815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a67accb3fd57d144000c28dd0d6c176387cd832b365de43f4e70d1d72632815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a67accb3fd57d144000c28dd0d6c176387cd832b365de43f4e70d1d72632815"
    sha256 cellar: :any_skip_relocation, sonoma:        "69c12afa9322543cdce1cddee254ff6bc0c432e7a279e8e136f5c10edd051f61"
    sha256 cellar: :any_skip_relocation, ventura:       "69c12afa9322543cdce1cddee254ff6bc0c432e7a279e8e136f5c10edd051f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d253d51772389e3be0429c17c850b30ee632bcc80edad8b8aebda341a97347a6"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "tidy"

    ldflags = "-s -w -X github.comgetsopssopsv3version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdsops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}sops #{pkgshare}example.yaml 2>&1", 128)
  end
end