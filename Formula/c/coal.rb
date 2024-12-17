class Coal < Formula
  desc "Extension of the Flexible Collision Library"
  homepage "https:github.comcoal-librarycoal"
  url "https:github.comcoal-librarycoalreleasesdownloadv3.0.0coal-3.0.0.tar.gz"
  sha256 "6a9cbd4684e907fd16577e5227fbace06ac15ca861c0846dfe5bc81e565fb1e7"
  license "BSD-2-Clause"
  revision 1
  head "https:github.comcoal-librarycoal.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17b165c8498f934efef7e8475a950e10ec647826ce84bcb48b8232daa2a10a22"
    sha256 cellar: :any,                 arm64_sonoma:  "b74507d8b5c6265b5478e0cd5bd05376d5fe789c270343b60facf99adcc9438d"
    sha256 cellar: :any,                 arm64_ventura: "5ec5d903dd1effa27d1c25014e63f2e8ec680c029bb82d30e64b9c04d5403579"
    sha256 cellar: :any,                 sonoma:        "e7f051a7f6f00f3fec8045ffd89b5d3a5bb8b2d946cb84653ef568a412550b70"
    sha256 cellar: :any,                 ventura:       "a7b257a4b5e303e3d89e929470e96227ea2312ef0a4e9ff0abedb3f22496e948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d80670cbb2119fa906b0c2d2c616c8795782515d8d90859e0250923a2ca8e56"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "octomap"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefixLanguage::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share"eigen3cmake"

    # enable backward compatibility with hpp-fcl
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DCOAL_BACKWARD_COMPATIBILITY_WITH_HPP_FCL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    %w[hppfcl coal].each do |module_name|
      system python3, "-c", <<~PYTHON
        exec("""
        import #{module_name}
        radius = 0.5
        sphere = #{module_name}.Sphere(0.5)
        assert sphere.radius == radius
        """)
      PYTHON
    end
  end
end