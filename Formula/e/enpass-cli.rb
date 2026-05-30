class EnpassCli < Formula
  desc "Enpass command-line client"
  homepage "https://github.com/hazcod/enpass-cli"
  url "https://ghfast.top/https://github.com/hazcod/enpass-cli/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "cad86d412f8a40bb0b161f52a875e50ca3de9544718831fe18c8f1cefaceee49"
  license "MIT"
  head "https://github.com/hazcod/enpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "831c7e30138e064c67bc0eeee8d015735d4576d9a9ec88db2f0e16e0dd439909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f4dd290ad91606dd40719a4e30a888f2c50f3078aae39f76ee81d9e553d9249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbf23f76a6529f48359b4df3cd1a743531d59e7b159819fc124e5fadc529fb0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eb51dd6d4c0686dea9a1953ef1863309ba6184cb31b90814f3d661735460037"
    sha256 cellar: :any,                 arm64_linux:   "084b50f6c2f0d275bbd18e94ed460290123f24b750f3a474a0880fad0349dbb8"
    sha256 cellar: :any,                 x86_64_linux:  "bcf3b8c529e9cbe49b15dd1d17e84748bdbe7088dec5729cddd780dbab1a7e51"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=#{version}'"), "./cmd/enpasscli"
    pkgshare.install "test/vault.json", "test/vault.enpassdb"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/enpass-cli version 2>&1")

    # Get test vault files
    mkdir "testvault"
    cp [pkgshare/"vault.json", pkgshare/"vault.enpassdb"], "testvault"
    # Master password for test vault
    ENV["MASTERPW"] = "absolutely-No-clue"
    # Retrieve password for "johndoe" from test vault
    assert_match "noIdeaata11", shell_output("#{bin}/enpass-cli -vault testvault/ pass johndoe").chomp
  end
end