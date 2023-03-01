class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://ghproxy.com/https://github.com/cupcakearmy/autorestic/archive/v1.7.5.tar.gz"
  sha256 "8fef2ac2e4de39a4c4e0668133455c1c30dd2a4b002f872a29a37dd44e321d80"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8be9d247c26a6908c55532027a424aab7d8008b0324a431a635c5ebcf30e94f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be9d247c26a6908c55532027a424aab7d8008b0324a431a635c5ebcf30e94f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8be9d247c26a6908c55532027a424aab7d8008b0324a431a635c5ebcf30e94f9"
    sha256 cellar: :any_skip_relocation, ventura:        "e5015b446ddb05c993c125d2aa69c2dfa4154b0e63040274302f178f396d4520"
    sha256 cellar: :any_skip_relocation, monterey:       "e5015b446ddb05c993c125d2aa69c2dfa4154b0e63040274302f178f396d4520"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5015b446ddb05c993c125d2aa69c2dfa4154b0e63040274302f178f396d4520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94bfe95394d1d9a5cad7387b41612ed3a9f56cfe3e5d0aeed8112c3b1a1e8700"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args, "./main.go"
    generate_completions_from_executable(bin/"autorestic", "completion")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2
    File.write(testpath/".autorestic.yml", config.to_yaml)
    (testpath/"repo"/"test.txt").write("This is a testfile")
    system "#{bin}/autorestic", "check"
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end