class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https:thanos.io"
  url "https:github.comthanos-iothanosarchiverefstagsv0.39.0.tar.gz"
  sha256 "eb75c3b61361951145246f9ffb3953735dfb6739d2b5b17d609db93e3250958a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff3041e2da686d0c1e9a743ec8149191b9aa98e290b56dada3d2cc1ab2cadacf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a47a10f4eb3938d2b503b8abeca5344850a9d215fc00a651c7c3ddcb588e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52088ec1d73f9e2560b9cbd7ad979b53ebf93b2e2d22d04c5fb3e7808e06fcc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af2ccf5b391c0e9a7214c67e1950f2e9d3d8c49575af782094c3bc6e24761a2"
    sha256 cellar: :any_skip_relocation, ventura:       "38d6657167ae52e0419a5e4c4315c5e2f497fbf8f69de21f984bee9772d227e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71d028e0371ba3e7310a2954ed493559b56073723edab6fe900be5deb89ce9f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdthanos"
  end

  test do
    (testpath"bucket_config.yaml").write <<~YAML
      type: FILESYSTEM
      config:
        directory: #{testpath}
    YAML

    output = shell_output("#{bin}thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end