class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https:thanos.io"
  url "https:github.comthanos-iothanosarchiverefstagsv0.36.0.tar.gz"
  sha256 "b5de2c4b8900a2a64766ded406ac5e573d37d5c11dc6620b9a1a6830df8da586"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "955af50af61bdedf128e786d621456af92e95547f71f987bf19eff3bcdcd7754"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8991f5eb403b9cc2557f5269f086e879037b6c8b43c833ee328ba4bedaf0dd22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c25722ddf8338d5881ee0671e91855a19df958c9ec005730cc4c39c70a7b5ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "528fdf7290c531a03eac195d608144e8fac3b01115df09f49674471fc034a23e"
    sha256 cellar: :any_skip_relocation, ventura:        "8cc2c6a3eae0e96dac46a66e4121880ac3026a84938f38335ad07e8bd9741c88"
    sha256 cellar: :any_skip_relocation, monterey:       "48837ec8446827a71a75ea1056e1c1a4f617d1f3bf53a6551821bc2f846f9c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b52f24d8e4a11721eb399230774c3f4a2675aeff19ae62e11d7b363f25f646e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdthanos"
  end

  test do
    (testpath"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end