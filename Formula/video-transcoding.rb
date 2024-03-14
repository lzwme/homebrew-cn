class VideoTranscoding < Formula
  desc "Tools to transcode, inspect and convert videos"
  homepage "https:github.comdonmeltonvideo_transcoding"
  url "https:github.comdonmeltonvideo_transcodingarchiverefstags0.25.3.tar.gz"
  sha256 "e261dab181b8bba6c9f7b948b1808f5e3b98d68d131267dcfe1b765ccfc50adc"

  depends_on "ffmpeg"
  depends_on "handbrake"
  depends_on "mkvtoolnix"
  depends_on "mp4v2"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "video_transcoding.gemspec"
    system "gem", "install", "video_transcoding-#{version}.gem"
    bin.install Dir[libexec"bin*"]
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end
end