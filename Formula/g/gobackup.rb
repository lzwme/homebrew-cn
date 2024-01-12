class Gobackup < Formula
  desc "CLI tool for backup your databases, files to cloud storages"
  homepage "https:gobackup.github.io"
  url "https:github.comgobackupgobackuparchiverefstagsv2.8.0.tar.gz"
  sha256 "7b356a74728756db04ae06b0eda600030c4842a13fa548ae521566b49a244ae0"
  license "MIT"
  head "https:github.comgobackupgobackup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70115978b58b6fb60f940313ae31bf81a42eb39bb13dff937586d18b128afab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d006e032918e4a29efecb3b8a8b4c293353f6bb14d67611781b7e4e1a406d5d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da138f4568b288bb0daaa50ad8b8c712aa0c984a742d17454dff1593880c35c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5fd3cd371d5f3700a2c66289a00e4a58ff44c7582cccc6df8bb46852f7c829f"
    sha256 cellar: :any_skip_relocation, ventura:        "792bea53e2ad9f836c85b94b155e7b13aa3ac8968b1fd3dfd879d8bbabc9d0fe"
    sha256 cellar: :any_skip_relocation, monterey:       "8f16cfbcec8864ac3fed587fd33380d26e10363af6e8d701ab5495a2ed167fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fd2e7ace46533ebd64c34b26ba853b0ba4dd4d542e50461e39f87cc4f23697e"
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

    config_file.write <<~EOS
      models:
        test:
          storages:
            local:
              type: local
              path: #{testpath}backups
          archive:
            includes:
              - #{config_file}
    EOS

    out = shell_output("#{bin}gobackup perform -c #{config_file}").chomp
    assert_match "succeeded", out
    tar_files = Dir.glob("#{testpath}backups*.tar")
    assert_equal 1, tar_files.length
  end
end