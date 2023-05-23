class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.3.5",
    revision: "1a8531957aa35eba5a247666ef21d6c8ae57d8a2"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9ba10d0caa19e703afe67dab4ea93dbbbc46e49dc6c5b299cccb92915b05bc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1a9f33ab9eb313504738be32ecc5b915c7b4f338ac64d3191aadd06ea3a2ee5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "806af7b4ef0297476dc8e8be6ee5b7f65401ae4372787ffc9358d9d7e31e1f14"
    sha256 cellar: :any_skip_relocation, ventura:        "a505b780f33bb7e1a9b9680d7b226f609be4625c22b70d0d1ac5707f12962850"
    sha256 cellar: :any_skip_relocation, monterey:       "428d788a6557120fc38d50a65f18f6287ccbe505afb71a5906782f190cf7b45a"
    sha256 cellar: :any_skip_relocation, big_sur:        "39ea4fc754ad9714b8a4c974467bac930d2c9281465772af9bba098a59e06e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ebdab5d0cf840ad7b9b905cad77a1839ef4ac853bfc7c455c1d7f6bfd971860"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    prefix.install "bin"

    generate_completions_from_executable(bin/"yorkie", "completion")
  end

  service do
    run opt_bin/"yorkie"
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    yorkie_pid = fork do
      exec bin/"yorkie", "server"
    end
    # sleep to let yorkie get ready
    sleep 3
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end