class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do healthstatus checking"
  homepage "https:github.commegaeaseeaseprobe"
  url "https:github.commegaeaseeaseprobearchiverefstagsv2.3.0.tar.gz"
  sha256 "84c91cb784073516393b33bf58093f2236eaccfab5833c682640cef71c225450"
  license "Apache-2.0"
  head "https:github.commegaeaseeaseprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e651583b7e1cbb5b8597c0dc57f72bb9a27244f7806799907ce3d9f239dfdef2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f184ec25e2c3e91faf168299f7595d19a24b2a50de0998f2b792fae31e98284"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "923ee63a279cd0282b59675c1fdf0ce85d9360a4fdae67fdcece5187b208183e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1337da6865466ead30338bb72c0f0eedb1214f5432180ac2db589018082c5732"
    sha256 cellar: :any_skip_relocation, ventura:       "415a686c94a56d4a49bf7a10fe1840eb1deeb5b489f1eaf1208c3915fa9239c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa4762a61a546533ba77c2d8b742f646a263dfb99946454dd939cd635190bcf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commegaeaseeaseprobepkgversion.RELEASE=#{version}
      -X github.commegaeaseeaseprobepkgversion.COMMIT=#{tap.user}
      -X github.commegaeaseeaseprobepkgversion.REPO=megaeaseeaseprobe
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdeaseprobe"
  end

  test do
    (testpath"config.yml").write <<~YAML.chomp
      http:
        - name: "brew.sh"
          url: "https:brew.sh"
      notify:
        log:
          - name: "logfile"
            file: #{testpath}easeprobe.log
    YAML

    easeprobe_stdout = (testpath"easeprobe.log")

    pid = fork do
      $stdout.reopen(easeprobe_stdout)
      exec bin"easeprobe", "-f", testpath"config.yml"
    end
    sleep 2
    assert_match "Ready to monitor(http): brew.sh", easeprobe_stdout.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end