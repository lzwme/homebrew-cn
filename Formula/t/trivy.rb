class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.51.4.tar.gz"
  sha256 "d782158eda0bdb8a915feadb85b292c69444b3d2bcea2112fcc1739013beb063"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "112744b76290a34bfd85d716a746e6ea0fae9d13bede3fc8cef1711330e50c88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbef92bf639af0422aa7f96b9f9f876d05d26ff07322d170d36df538e0a95607"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8c1da23e4e66f49b69030a60e6f9d737c8b040f020256f01737ccc01b766af"
    sha256 cellar: :any_skip_relocation, sonoma:         "34b72389bfe3a56a8df917fae12c95ca62d1d805f85b4d8336859d9eac4dc885"
    sha256 cellar: :any_skip_relocation, ventura:        "856f338f3b7a68dd2ec5ef49881a4d1d1e9ee9b7e339da43ccb76cdc4408a005"
    sha256 cellar: :any_skip_relocation, monterey:       "3d90851e3331bdfa01e4fb7b195e1d0cf4eec9de1364ef62b1ea34d31b1ced44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634860dc57854a8549454358d1bf499bcf718417a8b66736920361e600f54f2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversion.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end