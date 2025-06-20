class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https:openfast.readthedocs.io"
  url "https:github.comopenfastopenfast.git",
      tag:      "v4.1.0",
      revision: "8d2470b876a5229f9e4adf0391bda32096ed43b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "222c085d813b35f084bf25881c34fdf955bb520fa0e7b65a1c6b260b5198cdd1"
    sha256 cellar: :any,                 arm64_sonoma:  "494c5e36216b302269e921bf490366c36959d28a159c0037d2868f17f8109018"
    sha256 cellar: :any,                 arm64_ventura: "4c554347d8d3c7e872cae227db7bacacda12db07a322f948e6cd9d2c290d7f2a"
    sha256 cellar: :any,                 sonoma:        "5cea9d06f4a0b9ef89eafb945b16e735892b3fd2a416dd9eb80e176b4c719b1e"
    sha256 cellar: :any,                 ventura:       "98e2267164a7054452a89a77f0a909a9ce4957d2e238939f65808309384628e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b34ab2e020c3509bf0434f1e959e876b933feb7dc7b164c0f2425b267042cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093192f6ca0d346c782e8e7cfb60805b0f83e2c92ce074e05964315d75ec08d1"
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