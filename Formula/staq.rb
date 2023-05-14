class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://ghproxy.com/https://github.com/softwareQinc/staq/archive/v3.1.tar.gz"
  sha256 "24be03ff9d422170f4bf63a7ccc17efcbe405cac127d7141abc62b681c27f10c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcffd48b55a0cad46e9250678a7dac4da556553e97df5fc198dbb14882450642"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4cc5312f40529c67b8562b522b756df9fb58fbc2e8663ec495e10b0e1ea467f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf20a77fd1a789f2760d3df72f87369e2be4dbcc191c76d102bd7eb99bc1e58d"
    sha256 cellar: :any_skip_relocation, ventura:        "f94f2c73606197dc228ae087a03def820a3f16a9537a4cc1ec7dc6e309378acb"
    sha256 cellar: :any_skip_relocation, monterey:       "8dc40c4160bc74ecc655d523b2b863a3ac3853d4ae0a57411a03c9e67d32789f"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c206bfd03e1af93e55d13f3b43a66a3219d7800555c65fa2d31566db65cc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a651afeba26e350594dd161633b96f2678da3ae1b1abdada127deb2354a83a0f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.qasm").write <<~EOS
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      h q[0];
      h q[0];
      measure q->c;
    EOS
    assert_equal <<~EOS, shell_output("#{bin}/staq -O3 ./input.qasm").chomp
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      measure q[0] -> c[0];
    EOS
  end
end