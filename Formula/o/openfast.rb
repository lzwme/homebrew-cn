class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https:openfast.readthedocs.io"
  url "https:github.comopenfastopenfast.git",
      tag:      "v4.0.2",
      revision: "fc1110183bcc87b16d93129edabdce6d30e3a497"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd5095bbe049469485f3251f40bda7f44bfa958171c39131c5a78e960ec5c1ce"
    sha256 cellar: :any,                 arm64_sonoma:  "eec9172028aaf509b0786bebe58396d929d6a17cfa0b1f4621e4901bdd3794a0"
    sha256 cellar: :any,                 arm64_ventura: "7bbd8132a6d9ef494306b27be5ca7a6bf1e341ab69dd39212cd2afb07a897da6"
    sha256 cellar: :any,                 sonoma:        "7a7fcd497c537582743ecd8bda6120ec76089d46487deb042ae3a03b2dea5ee0"
    sha256 cellar: :any,                 ventura:       "d102edc70850fbb4ea05026cd4a76cf2263991d90c975df3d18f36e78284a7e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f85ffdd7b33027542793b0f1e3f460faaa3c2843389d06cf3e7dfcb224cf1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4400e775dde1f8dc1654f8bf33333dd2359a2f4b1082172a8064dd651cdf8563"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "netcdf"
  depends_on "openblas"

  def install
    args = %w[
      -DDOUBLE_PRECISION=OFF
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", ".", "--target", "openfast"
    bin.install "glue-codesopenfastopenfast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}openfast -h")
  end
end