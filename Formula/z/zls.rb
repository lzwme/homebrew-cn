class Zls < Formula
  desc "Language Server for Zig"
  homepage "https:zigtools.orgzls"
  url "https:github.comzigtoolszlsarchiverefstags0.13.0.tar.gz"
  sha256 "2e8046b6b0de765a4bf4bb828345e2badc8b828bc257dc931d0f56b147684d9f"
  license "MIT"
  head "https:github.comzigtoolszls.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "40ae2eed62a206035ef1ac4744f0b29e57c608edc19256d6dbc4e5a04a9e6731"
    sha256 arm64_sonoma:   "ad033c76a56c3e673f5a98b858044b6cce0943e4efc1f65e1808e96e6bc35526"
    sha256 arm64_ventura:  "8cec98eb089329c697832b25e173f6b136c007dfbcb6c3831d6b20df9ca65738"
    sha256 arm64_monterey: "dc17fa3ed91c7f1fe2f3978d5179f1b7d3bf49be1efe432c0de5c7934bc4b984"
    sha256 sonoma:         "0b9f2c664b2df58c11636bb2e79c29ea6fd3763ec294ad4df9752943241bf0f7"
    sha256 ventura:        "4b901bea62efa0dac5ab5301f50c6130bc749820e4c00769ab17fa6f33e7b9cc"
    sha256 monterey:       "c8f8837db476edf57943adc3a050c7f7514eec746f6d5deace1f0877a3ca6e08"
    sha256 x86_64_linux:   "efbbcc9ee2e1ff6189e5efe21281b621114c44091ca07e3e05fcb10ea4a3c60c"
  end

  depends_on "zig"

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https:github.comHomebrewhomebrew-coreissues92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[--prefix #{prefix} -Doptimize=ReleaseFast]
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    test_config = testpath"zls.json"
    test_config.write <<~JSON
      {
        "enable_semantic_tokens": true
      }
    JSON

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}zls --config-path #{test_config}", input, 1)
    assert_match(^Content-Length: \d+i, output)

    assert_match version.to_s, shell_output("#{bin}zls --version")
  end
end