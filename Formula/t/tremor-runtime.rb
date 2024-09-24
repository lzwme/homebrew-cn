class TremorRuntime < Formula
  desc "Early-stage event processing system for unstructured data"
  homepage "https:www.tremor.rs"
  url "https:github.comtremor-rstremor-runtimearchiverefstagsv0.12.4.tar.gz"
  sha256 "91cbe0ca5c4adda14b8456652dfaa148df9878e09dd65ac6988bb781e3df52af"
  license "Apache-2.0"
  head "https:github.comtremor-rstremor-runtime.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "efa5826b0b470f692379f07d5d1303ceb0fbf1dd8d5062185042461bcd390a71"
    sha256 cellar: :any,                 arm64_monterey: "4f373f2849cdb89dedf4edd77ba6742ecd4963cfcc104227ac54485822befe69"
    sha256 cellar: :any,                 arm64_big_sur:  "37a3edd0351331d3bdc1bebe3337cd37000cff71819d3345a748613a93cedb4a"
    sha256 cellar: :any,                 ventura:        "48cf6ebc8f669c2e4e888483b1bf798c736335efc1d94929238eb52b9b912fb9"
    sha256 cellar: :any,                 monterey:       "7764dfa50f3ceaa361799ea9f576e77f9d809a9bbc541688f331e605ade4109d"
    sha256 cellar: :any,                 big_sur:        "a6ab5749ffcfefc98be00158795203b8b99f17fee2c0c6985ee404082454ffb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df88e4137f9eb13a7f8c26324f7e97031335464d8505448131a8c6f1542352ac"
  end

  deprecate! date: "2024-09-23", because: :does_not_build

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "librdkafka"
  depends_on "oniguruma"
  depends_on "xz" # for liblzma

  on_linux do
    # Use `llvm@15` to work around build failure with Clang 16 described in
    # https:github.comrust-langrust-bindgenissues2312.
    # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
    # updated to 0.62.0 or newer. There is a check in the `install` method.
    depends_on "llvm@15" => :build
  end

  # gcc9+ required for c++20
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"

  # Fix invalid usage of `macro_export`.
  # Remove on next release.
  patch do
    url "https:github.comtremor-rstremor-runtimecommit986fae5cf1022790e60175125b848dc84f67214f.patch?full_index=1"
    sha256 "ff772097264185213cbea09addbcdacc017eda4f90c97d0dad36b0156e3e9dbc"
  end

  def install
    ENV["CARGO_FEATURE_DYNAMIC_LINKING"] = "1" # for librdkafka
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"

    bindgen_version = Version.new(
      (buildpath"Cargo.lock").read
                              .match(name = "bindgen"\nversion = "(.*)")[1],
    )
    if bindgen_version >= "0.62.0"
      odie "`bindgen` crate is updated to 0.62.0 or newer! Please remove " \
           'this check and try switching to `uses_from_macos "llvm" => :build`.'
    end

    inreplace ".cargoconfig", "+avx,+avx2,", ""

    system "cargo", "install", *std_cargo_args(path: "tremor-cli")

    generate_completions_from_executable(bin"tremor", "completions", base_name: "tremor")

    # main binary
    bin.install "targetreleasetremor"

    # stdlib
    (lib"tremor-script").install (buildpath"tremor-scriptlib").children

    # sample config for service
    (etc"tremor").install "dockerconfigdocker.troy" => "main.troy"

    # wrapper
    (bin"tremor-wrapper").write_env_script (bin"tremor"), TREMOR_PATH: "#{lib}tremor-script"
  end

  # demo service
  service do
    run [opt_bin"tremor-wrapper", "run", etc"tremormain.troy"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var"logtremor.log"
    error_log_path var"logtremor_error.log"
  end

  test do
    assert_match "tremor #{version}\n", shell_output("#{bin}tremor --version")

    (testpath"test.troy").write <<~EOS
      define flow test
      flow
          use tremor::connectors;

          define pipeline capitalize
          into
              out, err, exit
          pipeline
              use std::string;
              use std::time::nanos;
              select string::uppercase(event) from in into out;
              select {"exit": 0, "delay": nanos::from_seconds(1) } from in into exit;
          end;

          define connector file_in from file
              with codec="string", config={"path": "#{testpath}in.txt", "mode": "read"}
          end;
          define connector file_out from file
              with codec="string", config={"path": "#{testpath}out.txt", "mode": "truncate"}
          end;

          create pipeline capitalize from capitalize;
          create connector input from file_in;
          create connector output from file_out;
          create connector exit from connectors::exit;

          connect connectorinput to pipelinecapitalize;
          connect pipelinecapitalize to connectoroutput;
          connect pipelinecapitalizeexit to connectorexit;
      end;

      deploy flow test;
    EOS

    (testpath"in.txt").write("hello")

    system bin"tremor-wrapper", "run", testpath"test.troy"

    assert_match(^HELLO, (testpath"out.txt").readlines.first)
  end
end