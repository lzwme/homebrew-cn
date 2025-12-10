class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v4.8.2.tar.gz"
  sha256 "a1db420bf5bd15a071a4a5165a2036b959b8c741f5535b0bad7b20a09ffdbacf"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b15eb7230075af852e3044edea8bf7481e2acbfe99a347a2bb48c96007490c6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "919dda56b4ca47b9ae1503fb8e27ef2ac47bc2d0c07fb0fb14a55f026f261947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d34018ff71a4e585ab6c12d56e4d1f2b0ad441fdb8c88dcccbd38bf29b6b5e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "825cbf0a76cdfdfbe10389a18f2d341e7a6d8de5ede662021cab817c9b646ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "933f21789584273d28ae7470ce2676d9baba9f1b81a011c32e8afb42eae7f462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6ffd44a57761dd4ca61ebd0633a9ea616dda2eeb43a0d6d3eae259983dba305"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"2ms"), "main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/2ms --version")

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end