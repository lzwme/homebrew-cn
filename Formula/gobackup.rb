class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https://gobackup.github.io"
  url "https://ghproxy.com/https://github.com/gobackup/gobackup/archive/v2.5.2.tar.gz"
  sha256 "df5606d5a3e935065295ac0946f9f1dbbbfb62e349a17e5b0eae72f09d95fd0e"
  license "MIT"
  head "https://github.com/gobackup/gobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c8fe5207767d1aff8e045e286357c70ae46428beb95332dfa9d0b3367216aef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c8fe5207767d1aff8e045e286357c70ae46428beb95332dfa9d0b3367216aef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c8fe5207767d1aff8e045e286357c70ae46428beb95332dfa9d0b3367216aef"
    sha256 cellar: :any_skip_relocation, ventura:        "bc8829539a8b411fcbfcbb4d8dadba78a120135b2d34b786811fbf3be1893bb0"
    sha256 cellar: :any_skip_relocation, monterey:       "bc8829539a8b411fcbfcbb4d8dadba78a120135b2d34b786811fbf3be1893bb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc8829539a8b411fcbfcbb4d8dadba78a120135b2d34b786811fbf3be1893bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68d788d0830b156a21a891f07b7ff314d3e8f8b16db57aa88827736e7960adda"
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