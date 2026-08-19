class Mox < Formula
  desc "Modern full-featured open source secure mail server"
  homepage "https://www.xmox.nl"
  url "https://ghfast.top/https://github.com/mjl-/mox/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "a75fab03842debd6f3b8820acf58e767f4b193b24393dd4ef4ad05c29f82ecef"
  license "MIT"
  head "https://github.com/mjl-/mox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9f757dd29b70636462ed56ccc708d6da2a9aa5092d882918c4ea2067336ed38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9f757dd29b70636462ed56ccc708d6da2a9aa5092d882918c4ea2067336ed38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f757dd29b70636462ed56ccc708d6da2a9aa5092d882918c4ea2067336ed38"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b496ac370032595a89df98905dbe3577c8c7e96e589a7b27af44075d7fb92b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4d61e4435cf95a62f7f381eaa7a61911e9fb3b8ed59cdc60632e05f038b22b4"
    sha256 cellar: :any,                 x86_64_linux:  "58986024b4aa8b5324310a80cf265560690ec5710f908d879aaa28b433a03aee"
  end

  depends_on "go" => :build

  # Allow setting the version during buildtime
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/NixOS/nixpkgs/1ac75001649e3822e9caffaad85d7f1db76e9482/pkgs/by-name/mo/mox/version.patch"
    sha256 "5c35e348e27a235fad80f6a8f68c89fb37d95c9152360619795f2fdd5dc7403f"
    type :unofficial
  end

  def install
    ldflags = %W[
      -X github.com/mjl-/mox/moxvar.Version=#{version}
      -X github.com/mjl-/mox/moxvar.VersionBare=#{version}
      -X main.changelogURL=none
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    user = ENV["USER"]
    system bin/"mox", "quickstart", "-skipdial", "email@example.com", user
    assert_path_exists testpath/"config"
    assert_path_exists testpath/"config/mox.conf"

    assert_match "config OK", shell_output("#{bin}/mox config test")

    assert_match version.to_s, shell_output("#{bin}/mox version")
  end
end