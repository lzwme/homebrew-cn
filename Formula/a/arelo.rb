class Arelo < Formula
  desc "Simple auto reload (live reload) utility"
  homepage "https:github.commakiuchi-darelo"
  url "https:github.commakiuchi-dareloarchiverefstagsv1.15.1.tar.gz"
  sha256 "1ee05f22bf6725e1966760107bfb2fc1170dc78ceab0556312419925001d916e"
  license "MIT"
  head "https:github.commakiuchi-darelo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5d176d6c5f55a772e2a0096986576107481428b9c455a1c32c83bbc18d6d4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d5d176d6c5f55a772e2a0096986576107481428b9c455a1c32c83bbc18d6d4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d5d176d6c5f55a772e2a0096986576107481428b9c455a1c32c83bbc18d6d4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "69a2910088cb5df94adb4e8529cc67f6cba7b0c06910795c31a80fc95f755516"
    sha256 cellar: :any_skip_relocation, ventura:       "69a2910088cb5df94adb4e8529cc67f6cba7b0c06910795c31a80fc95f755516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36f419762bf3de8b1b0f2cd2136956f1b5a5a4a9ec8b85e7ad3d990293ec2f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}arelo --version")

    (testpath"test.sh").write <<~EOS
      #!binsh
      echo "Hello, world!"
    EOS
    chmod 0755, testpath"test.sh"

    logfile = testpath"arelo.log"
    arelo_pid = spawn bin"arelo", "--pattern", "test.sh", "--", ".test.sh", out: logfile.to_s

    sleep 1
    touch testpath"test.sh"
    sleep 1

    assert_path_exists testpath"test.sh"
    assert_match "Hello, world!", logfile.read
  ensure
    Process.kill("TERM", arelo_pid)
    Process.wait(arelo_pid)
  end
end