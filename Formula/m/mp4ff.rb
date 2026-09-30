class Mp4ff < Formula
  desc "Tools for parsing and manipulating MP4/ISOBMFF files"
  homepage "https://github.com/Eyevinn/mp4ff"
  url "https://ghfast.top/https://github.com/Eyevinn/mp4ff/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "642b451f674fde115dc41d249fb9e8f0bbbe10ca8b9099a9cd55cb4cf9601efb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56cca18c08711a1c254470a0368852db4eea81e080296b00f43f4ee1205387c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56cca18c08711a1c254470a0368852db4eea81e080296b00f43f4ee1205387c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56cca18c08711a1c254470a0368852db4eea81e080296b00f43f4ee1205387c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e26ae898def3894e86c746a6a646cf54e658cca86626b520d6792820e992d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a0cb6a80d587c8ae381a7b4411c1c78b5fcc80a888986e9f8833f32749e49938"
  end

  depends_on "go" => :build

  def tools
    %w[
      mp4ff-crop mp4ff-decrypt mp4ff-defragment mp4ff-encrypt mp4ff-info
      mp4ff-mvhevc mp4ff-nallister mp4ff-pslister mp4ff-subslister
    ]
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    tools.each do |tool|
      system "go", "build", *std_go_args(output: bin/tool), "./cmd/#{tool}"
    end
  end

  test do
    resource "homebrew-init" do
      url "https://ghfast.top/https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.52.0/mp4/testdata/init.mp4"
      sha256 "09a99ab8be9a39c80dc41ac6d4c9539b16947aab95abbadec903bfcb7a322221"
    end

    resource "homebrew-segment" do
      url "https://ghfast.top/https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.52.0/mp4/testdata/1.m4s"
      sha256 "00dd5f29bc6ba64a9d8540cdbeda7a3e5be0f0ed67475ab307506d7462fc2d98"
    end

    resource "homebrew-prog" do
      url "https://ghfast.top/https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.52.0/mp4/testdata/prog_8s.mp4"
      sha256 "86651d2aa80c714440fee3499ac3dd258b75043c4ceb455d70babb7873b16feb"
    end

    resource "homebrew-subs" do
      url "https://ghfast.top/https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.52.0/cmd/mp4ff-subslister/testdata/multi_vttc.mp4"
      sha256 "1518ba79c86f28414f9285910f8118e00d3b70aa07c6a48ebb1f80b476b1192a"
    end

    resource "homebrew-mvhevc" do
      url "https://ghfast.top/https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.53.0/cmd/mp4ff-mvhevc/testdata/stereo_spatial.mp4"
      sha256 "caa53ab7cf493d5a59d98b0eb8788a6add5faac6b5adcba58e89fd533174f90e"
    end

    # Build a combined fragmented MP4 from init segment + media segment
    resource("homebrew-init").stage(testpath/"init")
    resource("homebrew-segment").stage(testpath/"seg")
    (testpath/"test.mp4").binwrite(
      (testpath/"init/init.mp4").binread + (testpath/"seg/1.m4s").binread,
    )

    # mp4ff-info: fragmented H.264 file structure
    output = shell_output("#{bin}/mp4ff-info #{testpath}/test.mp4")
    assert_match "[ftyp]", output
    assert_match "[moof]", output
    assert_match "[avc1]", output

    # mp4ff-nallister: list NAL units
    output = shell_output("#{bin}/mp4ff-nallister #{testpath}/test.mp4")
    assert_match "IDR_5", output

    # mp4ff-pslister: extract parameter sets
    output = shell_output("#{bin}/mp4ff-pslister -i #{testpath}/test.mp4 -c avc")
    assert_match "avc1.64001E", output

    # mp4ff-encrypt + mp4ff-decrypt round-trip
    key = "00112233445566778899aabbccddeeff"
    system bin/"mp4ff-encrypt", "-key", key, "-iv", "00000000000000000000000000000000",
           "-kid", key, "-scheme", "cenc", testpath/"test.mp4", testpath/"enc.mp4"
    output = shell_output("#{bin}/mp4ff-info #{testpath}/enc.mp4")
    assert_match "[encv]", output
    assert_match "[sinf]", output

    system bin/"mp4ff-decrypt", "-key", key, testpath/"enc.mp4", testpath/"dec.mp4"
    dec_info = shell_output("#{bin}/mp4ff-info #{testpath}/dec.mp4")
    assert_match "[avc1]", dec_info
    refute_match "[encv]", dec_info

    # mp4ff-defragment: fragmented to progressive
    system bin/"mp4ff-defragment", testpath/"test.mp4", testpath/"defrag.mp4"
    defrag_info = shell_output("#{bin}/mp4ff-info #{testpath}/defrag.mp4")
    assert_match "[stsz] size=260", defrag_info
    refute_match "[moof]", defrag_info

    # mp4ff-crop: progressive H.264
    testpath.install resource("homebrew-prog")
    input_info = shell_output("#{bin}/mp4ff-info #{testpath}/prog_8s.mp4")
    assert_match "[stsz] size=980", input_info
    output = shell_output("#{bin}/mp4ff-crop -d 2000 #{testpath}/prog_8s.mp4 #{testpath}/cropped.mp4")
    assert_match "endTime=2000ms", output
    cropped_info = shell_output("#{bin}/mp4ff-info #{testpath}/cropped.mp4")
    assert_match "[stsz] size=260", cropped_info

    # mp4ff-subslister: fragmented WebVTT subtitle segment
    testpath.install resource("homebrew-subs")
    output = shell_output("#{bin}/mp4ff-subslister #{testpath}/multi_vttc.mp4")
    assert_match '- cueText: "<c.white.bg_black>Ouais ! Belle gosse ! Voici 2 M !</c>"', output

    # mp4ff-mvhevc: inspect a stereo MV-HEVC (multi-view) track
    testpath.install resource("homebrew-mvhevc")
    output = shell_output("#{bin}/mp4ff-mvhevc info #{testpath}/stereo_spatial.mp4")
    assert_match "hvc1", output
    assert_match "lhvC", output
    assert_match "views=2", output

    # Version check for all tools
    tools.each do |tool|
      assert_match "#{tool} v#{version}", shell_output("#{bin}/#{tool} -version")
    end
  end
end