class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https:gobackup.github.io"
  url "https:github.comgobackupgobackuparchiverefstagsv2.13.0.tar.gz"
  sha256 "0eec629fcac1c23d63a70d7c1a464da808a5b3bb3ab0ac7bf7988555e978b76a"
  license "MIT"
  head "https:github.comgobackupgobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf3cfc6e8c3eba13ef16996c11847efbf0b9ad01a89a4d266ff07a5e48c11389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf3cfc6e8c3eba13ef16996c11847efbf0b9ad01a89a4d266ff07a5e48c11389"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf3cfc6e8c3eba13ef16996c11847efbf0b9ad01a89a4d266ff07a5e48c11389"
    sha256 cellar: :any_skip_relocation, sonoma:        "a36b6d3d933460b5d0c5c0d557a0c7d5e9dbddd490b1aa2adb2c8035413dc579"
    sha256 cellar: :any_skip_relocation, ventura:       "a36b6d3d933460b5d0c5c0d557a0c7d5e9dbddd490b1aa2adb2c8035413dc579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca03c4744cb1fd49e51476d09734e5b70dc10313acc4cc2a55768baebfcce80"
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
    assert_match version.to_s, shell_output("#{bin}gobackup -v")

    config_file = testpath"gobackup.yml"
    config_file.write <<~YAML
      models:
        test:
          storages:
            local:
              type: local
              path: #{testpath}backups
          archive:
            includes:
              - #{config_file}
    YAML

    out = shell_output("#{bin}gobackup perform -c #{config_file}").chomp
    assert_match "succeeded", out
    tar_files = Dir.glob("#{testpath}backups*.tar")
    assert_equal 1, tar_files.length
  end
end