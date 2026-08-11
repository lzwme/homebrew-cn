class Oclgrind < Formula
  desc "OpenCL device simulator and debugger"
  homepage "https://github.com/jrprice/Oclgrind"
  url "https://ghfast.top/https://github.com/jrprice/Oclgrind/archive/refs/tags/v26.03.1.tar.gz"
  sha256 "d21a705a2b71491b1505f34a50e14f9666516d1654c0e6745983408bb300e4c2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "31ae206f1e532e12e6c91ea8a04d2bb45eac04840037d166b4be646bb0807a83"
    sha256 cellar: :any, arm64_sequoia: "93b1e1b3a1e98e44373d6f86796bf330ff2fb6925d6bfa2419c502f535c77032"
    sha256 cellar: :any, arm64_sonoma:  "eea3648c693fac210cfc3b36edacd2a81ab6c4330aecffa775a8fbe8bb85c651"
    sha256 cellar: :any, sonoma:        "6f9a1a027083d754f8add426deda21eb2b461d7c7d607ef1031c25924fbe3f47"
    sha256 cellar: :any, arm64_linux:   "92a93c6980a57cf9e4331597dd012e111dacd85e55f2213ce7f3843afd75a37c"
    sha256 cellar: :any, x86_64_linux:  "b55aa809bcaaaff3bed3f385ee9d0bb5b77a852607d78a9e34f08e5ba5a8e408"
  end

  depends_on "cmake" => :build
  depends_on "readline"

  on_macos do
    depends_on "llvm@19" # FIXME: LLVM 20+ segfaults. Also seen upstream where CI using Homebrew LLVM was disabled
    depends_on "zstd"
  end

  on_linux do
    depends_on "opencl-headers" => :test
    depends_on "llvm"
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    rpaths = [rpath, rpath(target: llvm.opt_lib)]
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Install the optional ICD into #{prefix}/etc rather than #{etc} as it contains realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    (prefix/"etc/OpenCL/vendors").install "build/oclgrind.icd"
  end

  test do
    (testpath/"rot13.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <#{OS.mac? ? "OpenCL" : "CL"}/cl.h>

      const char rot13_cl[] = "                         \\
      __kernel void rot13                               \\
          (   __global    const   char*    in           \\
          ,   __global            char*    out          \\
          )                                             \\
      {                                                 \\
          const uint index = get_global_id(0);          \\
                                                        \\
          char c=in[index];                             \\
          if (c<'A' || c>'z' || (c>'Z' && c<'a')) {     \\
              out[index] = in[index];                   \\
          } else {                                      \\
              if (c>'m' || (c>'M' && c<'a')) {          \\
                out[index] = in[index]-13;              \\
              } else {                                  \\
                out[index] = in[index]+13;              \\
              }                                         \\
          }                                             \\
      }                                                 \\
      ";

      void rot13 (char *buf) {
        int index=0;
        char c=buf[index];
        while (c!=0) {
          if (c<'A' || c>'z' || (c>'Z' && c<'a')) {
            buf[index] = buf[index];
          } else {
            if (c>'m' || (c>'M' && c<'a')) {
              buf[index] = buf[index]-13;
            } else {
              buf[index] = buf[index]+13;
            }
          }
          c=buf[++index];
        }
      }

      int main() {
        char buf[]="Hello, World!";
        size_t srcsize, worksize=strlen(buf);

        cl_int error;
        cl_platform_id platform;
        cl_device_id device;
        cl_uint platforms, devices;

        error=clGetPlatformIDs(1, &platform, &platforms);
        error=clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 1, &device, &devices);
        cl_context_properties properties[]={
                CL_CONTEXT_PLATFORM, (cl_context_properties)platform,
                0};

        cl_context context=clCreateContext(properties, 1, &device, NULL, NULL, &error);
        cl_command_queue cq = clCreateCommandQueue(context, device, 0, &error);

        rot13(buf);

        const char *src=rot13_cl;
        srcsize=strlen(rot13_cl);

        const char *srcptr[]={src};
        cl_program prog=clCreateProgramWithSource(context,
                1, srcptr, &srcsize, &error);
        error=clBuildProgram(prog, 0, NULL, "", NULL, NULL);

        if (error == CL_BUILD_PROGRAM_FAILURE) {
          size_t logsize;
          clGetProgramBuildInfo(prog, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &logsize);

          char *log=(char *)malloc(logsize);
          clGetProgramBuildInfo(prog, device, CL_PROGRAM_BUILD_LOG, logsize, log, NULL);

          fprintf(stderr, "%s\\n", log);
          free(log);

          return 1;
        }

        cl_mem mem1, mem2;
        mem1=clCreateBuffer(context, CL_MEM_READ_ONLY, worksize, NULL, &error);
        mem2=clCreateBuffer(context, CL_MEM_WRITE_ONLY, worksize, NULL, &error);

        cl_kernel k_rot13=clCreateKernel(prog, "rot13", &error);
        clSetKernelArg(k_rot13, 0, sizeof(mem1), &mem1);
        clSetKernelArg(k_rot13, 1, sizeof(mem2), &mem2);

        char buf2[sizeof buf];
        buf2[0]='?';
        buf2[worksize]=0;

        error=clEnqueueWriteBuffer(cq, mem1, CL_FALSE, 0, worksize, buf, 0, NULL, NULL);
        error=clEnqueueNDRangeKernel(cq, k_rot13, 1, NULL, &worksize, &worksize, 0, NULL, NULL);
        error=clEnqueueReadBuffer(cq, mem2, CL_FALSE, 0, worksize, buf2, 0, NULL, NULL);
        error=clFinish(cq);

        puts(buf2);
      }
    C

    system ENV.cc, "rot13.c", "-o", "rot13", "-L#{lib}", "-loclgrind-rt"
    output = shell_output("#{bin}/oclgrind ./rot13 2>&1").chomp
    assert_equal "Hello, World!", output
  end
end