class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https://ml-explore.github.io/mlx/build/html/index.html"
  license all_of: [
    "MIT", # main license
    "Apache-2.0", # metal-cpp resource
  ]
  compatibility_version 6
  head "https://github.com/ml-explore/mlx.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/ml-explore/mlx/archive/refs/tags/v0.32.3.tar.gz"
    sha256 "4129039ddcb36cb860982b616c975a5b9b8e6d8fa97efa86335b4427c29c4b4b"

    # TODO: Remove when a release includes the macOS 27 fix in upstream PR #4594.
    # Adapted for this release's kernel layout: https://github.com/ml-explore/mlx/pull/4594
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ff61d3f2794860355e1d9316ca61b227feb4f0a8a5a947a46c45f61504c8addb"
    sha256 cellar: :any, arm64_tahoe:       "03fd34f25a4f94239579087cf7857fe68c3efa80f3e4389116cd7c6f59ae32e3"
    sha256 cellar: :any, arm64_sequoia:     "2c339dc778676bb6fe85706cdba5fbd795de1f68d3eb849a157c05b0809e032e"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nanobind" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python-setuptools" => :build
  depends_on "robin-map" => :build
  depends_on xcode: ["15.0", :build] # for metal
  depends_on arch: :arm64
  depends_on macos: :sonoma
  depends_on "python@3.14"

  # https://github.com/ml-explore/mlx/blob/v#{version}/CMakeLists.txt
  # Included in not_a_binary_url_prefix_allowlist.json
  resource "metal-cpp" do
    url "https://developer.apple.com/metal/cpp/files/metal-cpp_26.zip"
    sha256 "4df3c078b9aadcb516212e9cb03004cbc5ce9a3e9c068fa3144d021db585a3a4"
  end

  # Update to GIT_TAG at https://github.com/ml-explore/mlx/blob/v#{version}/mlx/io/CMakeLists.txt
  resource "gguflib" do
    url "https://ghfast.top/https://github.com/antirez/gguf-tools/archive/8fa6eb65236618e28fd7710a0fba565f7faa1848.tar.gz"
    sha256 "9e30bc1eb82cc2231150d39ce37dcdd6f844d6994fba18da83fc537a487ba86f"
  end

  deny_network_access!

  def install
    ENV.append_to_cflags "-I#{formula_opt_include("nlohmann-json")}/nlohmann"
    (buildpath/"gguflib").install resource("gguflib")
    (buildpath/"metal_cpp").install resource("metal-cpp")

    mlx_python_dir = prefix/Language::Python.site_packages(python3)/"mlx"

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `fmt`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    args = %W[
      -DUSE_SYSTEM_FMT=ON
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: mlx_python_dir)},-rpath,#{lib}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_GGUFLIB=#{buildpath}/gguflib
      -DFETCHCONTENT_SOURCE_DIR_METAL_CPP=#{buildpath}/metal_cpp
    ]

    ENV["CMAKE_ARGS"] = (args + std_cmake_args).join(" ")
    ENV[build.head? ? "DEV_RELEASE" : "PYPI_RELEASE"] = "1"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>

      #include <mlx/mlx.h>

      int main() {
        mlx::core::array x({1.0f, 2.0f, 3.0f, 4.0f}, {2, 2});
        mlx::core::array y = mlx::core::ones({2, 2});
        mlx::core::array z = mlx::core::add(x, y);
        mlx::core::eval(z);
        assert(z.dtype() == mlx::core::float32);
        assert(z.shape(0) == 2);
        assert(z.shape(1) == 2);
        assert(z.data<float>()[0] == 2.0f);
        assert(z.data<float>()[1] == 3.0f);
        assert(z.data<float>()[2] == 4.0f);
        assert(z.data<float>()[3] == 5.0f);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system "./test"

    (testpath/"test.py").write <<~PYTHON
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.allclose(mx.cos(x), mx.array(1.0))
    PYTHON
    system python3, "test.py"
  end
end

__END__
--- a/mlx/backend/metal/kernels/gated_delta_update_nax.h
+++ b/mlx/backend/metal/kernels/gated_delta_update_nax.h
@@ -127,8 +127,8 @@
       gemm_op
           .template get_right_input_cooperative_tensor<AType, BType, CType>();
   auto ct_c = gemm_op.template get_destination_cooperative_tensor<
-      decltype(ct_a),
-      decltype(ct_b),
+      metal::remove_addrspace_t<decltype(ct_a)>,
+      metal::remove_addrspace_t<decltype(ct_b)>,
       CType>();

   STEEL_PRAGMA_UNROLL
@@ -173,8 +173,8 @@
       gemm_op
           .template get_right_input_cooperative_tensor<AType, BType, CType>();
   auto ct_c = gemm_op.template get_destination_cooperative_tensor<
-      decltype(ct_a),
-      decltype(ct_b),
+      metal::remove_addrspace_t<decltype(ct_a)>,
+      metal::remove_addrspace_t<decltype(ct_b)>,
       CType>();

   STEEL_PRAGMA_UNROLL
@@ -226,8 +226,8 @@

   // Create matmul output in register
   auto ct_c = gemm_op.template get_destination_cooperative_tensor<
-      decltype(ct_a),
-      decltype(ct_b),
+      metal::remove_addrspace_t<decltype(ct_a)>,
+      metal::remove_addrspace_t<decltype(ct_b)>,
       CType>();

   // Load A in to left operand registers