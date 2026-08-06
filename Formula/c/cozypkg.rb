class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://ghfast.top/https://github.com/cozystack/cozystack/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "3420af09f783e589b5851dc925e6ef405b9dd0a83b086b8d6a3b9e0082e76eba"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca3a852c0eebca7febaf0bf53db4682d9a4230da1bc7d54956459cae3d3e7fe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "351e17a5fc76c1f8f1ca4f5c0fb0d024cf9bb20bdbe32a0b7bf4ee0451d09265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1df4df7b911f135782c0afd806e4f799f359ec3d4d4cceeeabf367b15316d41b"
    sha256 cellar: :any_skip_relocation, sonoma:        "050d9eca5d4a739d304d5ae9eb5a273788fe2729f5dbf8c1bf4d157b655aadd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "545b20ddc1e1a45bf32847c7c678a9229f65560abc7945628ef1bec6b309b536"
    sha256 cellar: :any,                 x86_64_linux:  "b0809a3a2dca83cefd95d019acf5d61059d216488ff1fc08421bc6bf623369e1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cozypkg"
    generate_completions_from_executable(bin/"cozypkg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    ENV["KUBECONFIG"] = testpath/"nonexistent-kubeconfig"
    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "failed to get kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end