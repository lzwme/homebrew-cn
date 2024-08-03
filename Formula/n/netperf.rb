class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "https:hewlettpackard.github.ionetperf"

  stable do
    url "https:github.comHewlettPackardnetperfarchiverefstagsnetperf-2.7.0.tar.gz"
    sha256 "4569bafa4cca3d548eb96a486755af40bd9ceb6ab7c6abd81cc6aa4875007c4e"

    # only needed for AUTHORS changes of the following patch
    patch do
      url "https:github.comHewlettPackardnetperfcommit328fe3b56a8753f6f700aac2b2df84dda5ce93a3.patch?full_index=1"
      sha256 "e9696cb3dfccb73a595127c281ab0dd820eb8b84a440c96ab2c393444654daed"
    end

    patch do
      url "https:github.comHewlettPackardnetperfcommit0b0cbbef75021134c83be0c3dd21878467e11144.patch?full_index=1"
      sha256 "7dc26cd94228135f4f623a761bfd30e0e37076bf79d9a2e896ca63a5b56969cc"
    end

    # only needed for AUTHORS changes of the following patch
    patch do
      url "https:github.comHewlettPackardnetperfcommitebc567aaad9b5d5808808c7d7aa78e80bb497e72.patch?full_index=1"
      sha256 "c16c4760e9b558fa3dfba95eabccabae5ee7775c610b917ad8c4d1d799119029"
    end

    patch do
      url "https:github.comHewlettPackardnetperfcommit40c8a0fb873ac07a95f0c0253b2bd66109aa4c51.patch?full_index=1"
      sha256 "072b24f7747d9e789422f0249be1023ee437628a8b5f56c3e27a5359daf55a92"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b8c8f0f6df4dbb4e85dd8870a47b12369c70a72d7a97701800d9a30c753cbc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0be8aca056a660d30656ed07a2915d75d085cda6c826fda6381ba6842b51622"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e3f88250483cc1a9b8752d9c93bb9764f97bd4110824b51cc0c1b61c6d1d62"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c596efc4287605732753cf615b4bafd51c9554ad51a4b497e4655f8ddff2e84"
    sha256 cellar: :any_skip_relocation, ventura:        "ae8920b6b1666b52f368c70401e444a6d287fc25a5c75215c463c7b9f25294b0"
    sha256 cellar: :any_skip_relocation, monterey:       "13f14c46d72fb02c70c54e68743fc4a63b99c5de54d4731c83d982f6dffa948f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ef9981c5c2d3f0e9d9d5718a86188a9b38ab8df08f2d92ac50aa371be2a764"
  end

  head do
    url "https:github.comHewlettPackardnetperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # (resolves "multiple definition of `...'" errors)
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # https:github.comHewlettPackardnetperfpull67
    inreplace "srcnetcpu_osx.c", "* #include <machmach_port.h> *", "#include <machmach_port.h>"
    inreplace "srcnetcpu_osx.c", "mach_port_deallocate(lib_host_port)",
      "mach_port_deallocate(mach_task_self(), lib_host_port)"

    system ".autogen.sh" if build.head?
    system ".configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage: netperf", shell_output("#{bin}netperf -h 2>&1", 1)
  end
end