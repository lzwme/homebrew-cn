class Yorkie < Formula
  desc "Document store for collaborative applications"
  homepage "https://yorkie.dev/"
  url "https://github.com/yorkie-team/yorkie.git",
    tag:      "v0.4.3",
    revision: "abf17ac4c31a08c8c6a622230a91134fa7ae357a"
  license "Apache-2.0"
  head "https://github.com/yorkie-team/yorkie.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f18f72c0370979c7c8522cc7b9573a21e940220ba5c038b270de14062b944d22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe222b76a4fcb15f7dbf71d95bca533e95cc270b46c38b601800da21287db80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3917010e1f01bc76d3ddcc0da5e3418c59ad0bf11503c1b08da5ecba1daa6974"
    sha256 cellar: :any_skip_relocation, ventura:        "da32581d6b8dbcd58ea8645c400c276694abaf3bf2e38bd1ebf87ae2f7589063"
    sha256 cellar: :any_skip_relocation, monterey:       "f4d35a9c39bf1652079c55d5dc4fa6f92c08df0f0c92bc8f7b836b189ab9313b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b223e356b3623d42daf8eab1765f943e969c2d6cbf859aae6605907f85bd83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1724f9e84a6fb15e3e9cfe0b532254fbb6868857ee2d32eae007b8663e0d125"
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
    system bin/"yorkie", "login", "-u", "admin", "-p", "admin", "--insecure"

    test_project = "test"
    output = shell_output("#{bin}/yorkie project create #{test_project} --insecure 2>&1")
    project_info = JSON.parse(output)
    assert_equal test_project, project_info.fetch("name")
  ensure
    # clean up the process before we leave
    Process.kill("HUP", yorkie_pid)
  end
end