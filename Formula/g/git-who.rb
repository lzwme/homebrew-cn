class GitWho < Formula
  desc "Git blame for file trees"
  homepage "https:github.comsinclairtargetgit-who"
  url "https:github.comsinclairtargetgit-whoarchiverefstagsv1.0.tar.gz"
  sha256 "c67cd80a48e1140f0c0eae100c86bcbe9cc3232046983559b37b91fa8387f55b"
  license "MIT"
  head "https:github.comsinclairtargetgit-who.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3fc7c9c8d9ffaf9b0ecab177642f88048b4be4c69dea359a22658df9becc7ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3fc7c9c8d9ffaf9b0ecab177642f88048b4be4c69dea359a22658df9becc7ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3fc7c9c8d9ffaf9b0ecab177642f88048b4be4c69dea359a22658df9becc7ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fa1c8a8916e9155e013cd2d837f81d54fa469b8ddd6860de58eda94a5fb45c7"
    sha256 cellar: :any_skip_relocation, ventura:       "8fa1c8a8916e9155e013cd2d837f81d54fa469b8ddd6860de58eda94a5fb45c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99712284e5607eb6523e764da7993c7ab7056a5edcf9fa1148efe58e7f1b3d59"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-who -version")

    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "git", "commit", "-m", "example"

    assert_match "example", shell_output("#{bin}git-who tree")
  end
end