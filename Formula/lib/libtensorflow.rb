class Libtensorflow < Formula
  desc "C interface for Google's OS library for Machine Intelligence"
  homepage "https:www.tensorflow.org"
  url "https:github.comtensorflowtensorflowarchiverefstagsv2.16.2.tar.gz"
  sha256 "023849bf253080cb1e4f09386f5eb900492da2288274086ed6cfecd6d99da9eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "266fe492f1bc5ef43a556439ee5e8eed0ace1d65b0eeeb389648166c170488c7"
    sha256 cellar: :any,                 arm64_ventura:  "92d25f0d8850487366d43d4a4c5bf220cf8b8dba1fa692b59ad5859467f89c1f"
    sha256 cellar: :any,                 arm64_monterey: "2815fc7726bed733f6678237f998eab685cc418070f44ecd3e6b33d67a2894b3"
    sha256 cellar: :any,                 sonoma:         "139abab6b1178c92e6492a3eebe7de7b09f0d63eb8df2e1c3fd4f19161446e5b"
    sha256 cellar: :any,                 ventura:        "250c369eee6784ae36604a5ea84f092b0883dfe63044b57f242d3ea5ff78bb1c"
    sha256 cellar: :any,                 monterey:       "0662c7a90b9ddf9e0453e222142d62fee3ec5e99247b4b6866329320534bcd89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b678e4782d06e0bb90d16081e8e016352d20bcefaa009ba1980125ef8e7f5b"
  end

  depends_on "bazelisk" => :build
  depends_on "numpy" => :build
  depends_on "python@3.12" => :build

  on_macos do
    depends_on "gnu-getopt" => :build
  end

  resource "homebrew-test-model" do
    url "https:github.comtensorflowmodelsrawv1.13.0sampleslanguagesjavatrainingmodelgraph.pb"
    sha256 "147fab50ddc945972818516418942157de5e7053d4b67e7fca0b0ada16733ecb"
  end

  def install
    python3 = "python3.12"
    optflag = if Hardware::CPU.arm? && OS.mac?
      "-mcpu=apple-m1"
    elsif build.bottle?
      "-march=#{Hardware.oldest_cpu}"
    else
      "-march=native"
    end
    ENV["CC_OPT_FLAGS"] = optflag
    ENV["PYTHON_BIN_PATH"] = which(python3)
    ENV["TF_IGNORE_MAX_BAZEL_VERSION"] = "1"
    ENV["TF_NEED_JEMALLOC"] = "1"
    ENV["TF_NEED_GCP"] = "0"
    ENV["TF_NEED_HDFS"] = "0"
    ENV["TF_ENABLE_XLA"] = "0"
    ENV["USE_DEFAULT_PYTHON_LIB_PATH"] = "1"
    ENV["TF_NEED_OPENCL"] = "0"
    ENV["TF_NEED_CUDA"] = "0"
    ENV["TF_NEED_MKL"] = "0"
    ENV["TF_NEED_VERBS"] = "0"
    ENV["TF_NEED_MPI"] = "0"
    ENV["TF_NEED_S3"] = "1"
    ENV["TF_NEED_GDR"] = "0"
    ENV["TF_NEED_KAFKA"] = "0"
    ENV["TF_NEED_OPENCL_SYCL"] = "0"
    ENV["TF_NEED_ROCM"] = "0"
    ENV["TF_NEED_CLANG"] = "0" if OS.linux?
    ENV["TF_DOWNLOAD_CLANG"] = "0"
    ENV["TF_SET_ANDROID_WORKSPACE"] = "0"
    ENV["TF_CONFIGURE_IOS"] = "0"
    system ".configure"

    bazel_args = %W[
      --jobs=#{ENV.make_jobs}
      --compilation_mode=opt
      --copt=#{optflag}
      --linkopt=-Wl,-rpath,#{rpath}
      --verbose_failures
    ]
    if OS.linux?
      pyver = Language::Python.major_minor_version python3
      env_path = "#{Formula["python@#{pyver}"].opt_libexec}bin:#{HOMEBREW_PREFIX}bin:usrbin:bin"
      bazel_args += %W[
        --action_env=PATH=#{env_path}
        --host_action_env=PATH=#{env_path}
      ]
    end
    targets = %w[
      tensorflowtoolslib_package:libtensorflow
      tensorflowtoolsbenchmark:benchmark_model
      tensorflowtoolsgraph_transforms:summarize_graph
      tensorflowtoolsgraph_transforms:transform_graph
    ]
    system Formula["bazelisk"].opt_bin"bazelisk", "build", *bazel_args, *targets

    bin.install %w[
      bazel-bintensorflowtoolsbenchmarkbenchmark_model
      bazel-bintensorflowtoolsgraph_transformssummarize_graph
      bazel-bintensorflowtoolsgraph_transformstransform_graph
    ]
    system "tar", "-C", prefix, "-xzf", "bazel-bintensorflowtoolslib_packagelibtensorflow.tar.gz"

    ENV.prepend_path "PATH", Formula["gnu-getopt"].opt_prefix"bin" if OS.mac?
    system "tensorflowcgenerate-pc.sh", "--prefix", prefix, "--version", version.to_s
    (lib"pkgconfig").install "tensorflow.pc"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <tensorflowcc_api.h>
      int main() {
        printf("%s", TF_Version());
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltensorflow", "-o", "test_tf"
    assert_equal version, shell_output(".test_tf")

    resource("homebrew-test-model").stage(testpath)

    summarize_graph_output = shell_output("#{bin}summarize_graph --in_graph=#{testpath}graph.pb 2>&1")
    variables_match = Found \d+ variables:.+$.match(summarize_graph_output)
    refute_nil variables_match, "Unexpected stdout from summarize_graph for graph.pb (no found variables)"
    variables_names = variables_match[0].scan(name=([^,]+)).flatten.sort

    transform_command = %W[
      #{bin}transform_graph
      --in_graph=#{testpath}graph.pb
      --out_graph=#{testpath}graph-new.pb
      --inputs=na
      --outputs=na
      --transforms="obfuscate_names"
      2>&1
    ].join(" ")
    shell_output(transform_command)

    assert_predicate testpath"graph-new.pb", :exist?, "transform_graph did not create an output graph"

    new_summarize_graph_output = shell_output("#{bin}summarize_graph --in_graph=#{testpath}graph-new.pb 2>&1")
    new_variables_match = Found \d+ variables:.+$.match(new_summarize_graph_output)
    refute_nil new_variables_match, "Unexpected summarize_graph output for graph-new.pb (no found variables)"
    new_variables_names = new_variables_match[0].scan(name=([^,]+)).flatten.sort

    refute_equal variables_names, new_variables_names, "transform_graph didn't obfuscate variable names"

    benchmark_model_match = benchmark_model -- (.+)$.match(new_summarize_graph_output)
    refute_nil benchmark_model_match,
      "Unexpected summarize_graph output for graph-new.pb (no benchmark_model example)"

    benchmark_model_args = benchmark_model_match[1].split
    benchmark_model_args.delete("--show_flops")

    benchmark_model_command = [
      "#{bin}benchmark_model",
      "--time_limit=10",
      "--num_threads=1",
      *benchmark_model_args,
      "2>&1",
    ].join(" ")

    assert_includes shell_output(benchmark_model_command),
      "Timings (microseconds):",
      "Unexpected benchmark_model output (no timings)"
  end
end