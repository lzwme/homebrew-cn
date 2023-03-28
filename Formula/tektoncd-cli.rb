class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://ghproxy.com/https://github.com/tektoncd/cli/archive/v0.30.0.tar.gz"
  sha256 "377e54a0d861a43216ecb63eddd2815ef3fb8f3e514eac6ad22cd9f148132642"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc549c41d062ee8b6693f6a9321eec90deb1c02c5ca89761275fe3b658fa8087"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b34030bc0fd70cefcc29c009b73ef8544873de165b36aff1af9ed96a128961ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5936458753c3336dabc171e99d9ddf0d69f2f4d3e218785c9732f624c4c6b691"
    sha256 cellar: :any_skip_relocation, ventura:        "38248f3ec96c75fe78dda2b236edc8245281216dc53afde420f48b57454d7161"
    sha256 cellar: :any_skip_relocation, monterey:       "661b69a9953a252f08b9384fe9c686c2c3488005a382e6f621e8c2c264087ebc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7079cd95201ac235f35fe8ef6437106a01d5d495d82d91f0a4842aa6eeb78dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7319c7edacaffcae50b1374db20d152ef8b195fcf42536c86ccae481aa848db6"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end