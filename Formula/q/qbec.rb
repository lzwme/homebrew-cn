class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://ghfast.top/https://github.com/splunk/qbec/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "695655a2e1b73f261cd912b9861fb7f9868de6084117d2862da40e0a0d0e61c1"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3f75b2207008d35a2c8415be3594e568e52950cfb25988f4a1048907f0784c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "874b79d4452f007950d69b5bcc04d396c3b20e252b358b510ac7550ccfd58d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9753343d85518350b3707b6234c7e731aa8334df71fa9aaef725c7cd8b5b736d"
    sha256 cellar: :any_skip_relocation, sonoma:        "94680c8d457bb019c4034f63081ea38bd7755d103dc9e698936577329f17969b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5680d7fa51b7f9b7bf6392b8c6ec72a297155cc9946df061258060ecce4fab07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb8fd321f87c1a2277ce2f7d351305797e428b2916bf86b886aea6eaf8b1162"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end