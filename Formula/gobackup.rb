class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://ghproxy.com/https://github.com/gobackup/gobackup/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "984504dd85e882fe25c02e09f7fcbefa909da349ce2c16c865c6bff65dbef048"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d2031b7d70c761124f07c99bf51b7c66affe94a150a8e42beed255e5ed5eeb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2b13d1f4608060266cf2fbb0b90195b3be0ef1ddce94663aad7d2625080d7aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1ed3808eb16fa4618ecd6e5ab956b26682d12c61e33cbd37f442da80d2291b6"
    sha256 cellar: :any_skip_relocation, ventura:        "ef494cd0b73f8e4837e04a058482bd61ec2365ac25a8e8925a379e100e95147c"
    sha256 cellar: :any_skip_relocation, monterey:       "583682b00e589d328437417a6c13a6bb9282e8a97725de48589acc4e906e2a13"
    sha256 cellar: :any_skip_relocation, big_sur:        "752fa00b6ac0d50caaaeda5e9de5dc2afc081f09f7006a9347ffc514d42056e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "607c7fff9b5e18a1720d603025c3cf3c3afb04fe457658796a58906eb1592967"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    revision = build.head? ? version.commit : version

    chdir "web" do
      system "yarn", "install"
      system "yarn", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{revision}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobackup -v")

    config_file = testpath/"gobackup.yml"

    config_file.write <<~EOS
      models:
        test:
          storages:
            local:
              type: local
              path: #{testpath}/backups
          archive:
            includes:
              - #{config_file}
    EOS

    out = shell_output("#{bin}/gobackup perform -c #{config_file}").chomp
    assert_match "succeeded", out
    tar_files = Dir.glob("#{testpath}/backups/*.tar")
    assert_equal 1, tar_files.length
  end
end