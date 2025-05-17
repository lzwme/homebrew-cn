class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.92.1.tar.gz"
  sha256 "c6ac75f6ab6774fbc52934c5ecf39db24c8cd3c3fecb546db4f2bf0f2def27ef"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd8d9601eaffed820f553990e09e90d2c2f86775f9d586a3f6a173edd3a650a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a48394ad3f39c22762b5cdd5456b023c1124e834bdff2b95a156fabcea314b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2dc6c4b21a854bad40b8dbd9a21dd7aca00330de492f95a00b1390c34d8183c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d86c74c5901d92409c54174cc05e1bc38e66ebd3c41e5fd577c804f24820e7f"
    sha256 cellar: :any_skip_relocation, ventura:       "d24641c39df87cb35078149bab4e58f767d8015ee92bf8a3dfefdad8561f88e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17d5e7cd00f678d4474e08cf9db6c002507d324cfd21aad16dc14a2aa0ade2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ee05713cd237f6ed6df858b73541f9a040f333c83f592ef539722b10b9f021"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end