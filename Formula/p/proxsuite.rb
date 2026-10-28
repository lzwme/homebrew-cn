class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghfast.top/https://github.com/Simple-Robotics/proxsuite/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "468864235f99b0ab2a07571ba42481dfd64a05ae28c71f8fbc684d874fd1fdb9"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "086f20beeec538a70d9841363d5f1ccfc54e508095322e1752e6f3984667f6b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c618b6aa3bcc7bf5d27a30099e9b3bb7111f0c75c9a726e6707c380e5d22e1ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e86360321477e848aed7496dd8d5cfbc23f01d5995a58f8ab2455bd359b6b258"
    sha256 cellar: :any,                 arm64_linux:       "c4079f7ee461f317e009237fb10892cca6c5392db290c9897ec2903bae2c5cb7"
    sha256 cellar: :any,                 x86_64_linux:      "f3f6522e8e816b49f48387075c38bd95a92c15704c605b6a5439493b28c30dc5"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "nanobind" => :build
  depends_on "pkgconf" => :build
  depends_on "cereal" => :no_linkage
  depends_on "eigen" => :no_linkage
  depends_on "numpy" => :no_linkage
  depends_on "python@3.15"
  depends_on "scipy" => :no_linkage
  depends_on "simde" => :no_linkage

  resource "jrl-cmakemodules" do
    url "https://ghfast.top/https://github.com/jrl-umi3218/jrl-cmakemodules/archive/refs/tags/v2.3.0.tar.gz"
    sha256 "840cfba922b9589695ee3da4da3f9472ceeefe8fe4bccbb7ed3e885d1ca978cf"
  end

  deny_network_access!

  def install
    resource("jrl-cmakemodules").stage buildpath/"jrl-cmakemodules"

    # Workaround to fix error: a template argument list is expected after
    # a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
    if DevelopmentTools.clang_build_version >= 1700
      ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw"
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_PYTHON_INTERFACE=ON
      -DINSTALL_DOCUMENTATION=ON
      -DJRL_CMAKEMODULES_SOURCE_DIR=#{buildpath}/jrl-cmakemodules
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    PYTHON
  end
end