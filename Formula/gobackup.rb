class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://ghproxy.com/https://github.com/gobackup/gobackup/archive/v2.5.0.tar.gz"
  sha256 "4034adb3a9d119dadc099b5837ef17f38bb10dd533d4ef138d25d08ca1957045"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "474ac102c077e8e592a52688190cd7d471c73e382fc5e99597cb194add1ae515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "474ac102c077e8e592a52688190cd7d471c73e382fc5e99597cb194add1ae515"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "474ac102c077e8e592a52688190cd7d471c73e382fc5e99597cb194add1ae515"
    sha256 cellar: :any_skip_relocation, ventura:        "0a1605f05066c72f172ce92053dd48c1d5bff9172733adeb71a02ec04cade662"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1605f05066c72f172ce92053dd48c1d5bff9172733adeb71a02ec04cade662"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a1605f05066c72f172ce92053dd48c1d5bff9172733adeb71a02ec04cade662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9176a74ad0fcdc97fee1e8495d25e39a66945b68a0e2ae46c3e25a89e2f54a21"
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