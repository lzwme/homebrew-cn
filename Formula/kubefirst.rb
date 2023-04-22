class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://ghproxy.com/https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "50e7e7a7489eb0f0b1ebec827690641d9e7f968ce7ee4475456d53df1a646cc4"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc78a4df3ea3209ee95c157c7d04cb97a23394195765060bb50f3a17b098a462"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "390a658fe4428089f0e313631871f3730abee299286cf63bb90a6c9527b812d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e3b15c075fe6be541dc0a8534824aa6043cb55e0e52caa12bf8402458afb678"
    sha256 cellar: :any_skip_relocation, ventura:        "ca3c49e16b2a2529bdcf17e3b56b3afc0d7eeb7dda3e28a03030f5fedffdfb88"
    sha256 cellar: :any_skip_relocation, monterey:       "cc48c8dff5d4cba84945ebbab1897fa8d3c00d3a8e9e960c8005c3c62bed143c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c36724534f3e7f794fc9e7422d5e89703d14786054f6d601873001c71ad1d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "315d2115723c4d0ab2bfcd3a37077a62f501d32f07cf7dae4d1277ddaba9c7bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end