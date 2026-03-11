class Topicctl < Formula
  desc "Declarative Kafka topic management"
  homepage "https://github.com/segmentio/topicctl"
  url "https://ghfast.top/https://github.com/segmentio/topicctl/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ac57bed1c6c387d050b8a7cd43c8b82457d7f34ac4bc4630ac8a6d989c8b0e69"
  license "MIT"
  head "https://github.com/segmentio/topicctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f71f5d8f760ec5e5772a82bebf1a9bd0b921d3267d259b8effb8210905572444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f71f5d8f760ec5e5772a82bebf1a9bd0b921d3267d259b8effb8210905572444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f71f5d8f760ec5e5772a82bebf1a9bd0b921d3267d259b8effb8210905572444"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d9804fa4bab8b68a3555e102184f763d8e22a6edcf18cba09441cd0414a95bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24889b807c09e8094152a1f5fcb32a67dfaac884afefb5333b3d1652358e92dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54f7b1d2d2b7ad45ec86e051ae83c44fa814b4e86d6ef4677901d91c3d6c2024"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/topicctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/topicctl --version")

    (testpath/"cluster.yaml").write <<~YAML
      meta:
        name: test-cluster
        environment: test-env
        region: test-region

      spec:
        bootstrapAddrs:
          - bootstrap-addr:9092
        zkAddrs:
          - zk-addr:2181
        zkPrefix: /test-cluster-id
        zkLockPath: /topicctl/locks
    YAML

    (testpath/"topics").mkpath
    (testpath/"topics/topic-test.yaml").write <<~YAML
      meta:
        name: topic-test
        cluster: test-cluster
        environment: test-env
        region: test-region

      spec:
        partitions: 9
        replicationFactor: 2
        retentionMinutes: 100
        placement:
          strategy: in-rack
        settings:
          cleanup.policy: compact
    YAML

    system bin/"topicctl", "check", "--validate-only", testpath/"topics/topic-test.yaml"
  end
end